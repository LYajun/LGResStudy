//
//  recorder.c
//  hellostream
//
//  Created by shun zhang on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "airecorder.h"
#include "aiplayer.h"
#include "wavehdr.h"

#include "AudioToolbox/AudioQueue.h"
#include "AudioToolbox/AudioFile.h"
#include "AudioToolbox/AudioConverter.h"
#include "CoreAudio/CoreAudioTypes.h"

#include <stdlib.h>
#include <stdio.h>


#define AIRECORDER_BUFFER_NUMBER 5
#define AIRECORDER_CALLBACK_INTERVAL_MAX 1000  // 1000ms
#define AIRECORDER_CALLBACK_INTERVAL_MIN 50    // 50ms

#define AIRECORDER_SAMPLE_RATE 16000
#define AIRECORDER_CHANNELS 1
#define AIRECORDER_BITS_PER_SAMPLE 16

struct airecorder
{
    AudioQueueRef          audio_queue;
    struct aiplayer      * player;
    /* AudioQueueBufferRef buffers[RECORDER_BUFFER_NUMBER]; */
    char                   wavpath[1024];
    FILE *                 wavfile;
    const void *           usrdata;
    airecorder_callback    callback;
    volatile int           is_running;
};


static FILE *
_fopen(const char * wavpath)
{
    FILE * file = NULL;

    WaveHeader header;

    int sample_rate = AIRECORDER_SAMPLE_RATE;
    int channels = AIRECORDER_CHANNELS;
    int bits_per_sample = AIRECORDER_BITS_PER_SAMPLE;

    file = fopen(wavpath, "w");
    if (file == NULL) {
        goto end;
    }

    strncpy(header.riff_id, "RIFF", 4);
    header.riff_datasize = 0;                   // placehoder
    
    strncpy(header.riff_type, "WAVE", 4);
    
    strncpy(header.fmt_id, "fmt ", 4);
    header.fmt_datasize = 16;
    header.fmt_compression_code = 1;
    header.fmt_channels = channels;
    header.fmt_sample_rate = sample_rate;
    header.fmt_avg_bytes_per_sec = sample_rate * bits_per_sample * channels / 8;
    header.fmt_block_align = bits_per_sample * channels / 8;
    header.fmt_bit_per_sample = bits_per_sample;
    
    strncpy(header.data_id, "data", 4);
    header.data_datasize = 0;                    // place hoder

    fwrite(&header, 1, sizeof(WaveHeader), file);

end:
    return file;
}


static size_t
_fwrite(FILE *file, const void * data, size_t size)
{
    return fwrite(data, 1, size, file);
}


static int
_fclose(FILE *file)
{
    int ret = -1;
    
    uint32_t file_size = 0;
    uint32_t riff_datasize = 0;
    uint32_t data_datasize = 0;
    
    if (!file) {
        goto end;
    }
    
    fseek(file, 0L, SEEK_END);
    file_size = (uint32_t)ftell(file);
    riff_datasize = file_size - 4;
    data_datasize = file_size - 44;
    
    fseek(file, 4L, SEEK_SET);
    fwrite(&riff_datasize, 1, 4, file);
    
    fseek(file, 40L, SEEK_SET);
    fwrite(&data_datasize, 1, 4, file);
    
    ret = fclose(file);
    
end:
    return ret;
}


static void
_callback(void * usrdata, AudioQueueRef audio_queue,
                          AudioQueueBufferRef buffer,
                          const AudioTimeStamp *start_time,
                          UInt32 packet_num,
                          const AudioStreamPacketDescription *packet_desc)
{
    struct airecorder * recorder = (struct airecorder *) usrdata;

    if (buffer->mAudioDataByteSize > 0) {
        if (recorder->callback) {
            recorder->callback(recorder->usrdata, buffer->mAudioData, buffer->mAudioDataByteSize);
        }

        if (recorder->wavfile) {
            _fwrite(recorder->wavfile, buffer->mAudioData, buffer->mAudioDataByteSize);
        }

/*
        if (recorder->wavfile
           && AudioFileWritePackets(recorder->wavfile,
                                  false,
                                  buffer->mAudioDataByteSize,
                                  packet_desc,
                                  recorder->written_packets,
                                  &packet_num,
                                  buffer->mAudioData
                                  ) == noErr)
        {
            recorder->written_packets += packet_num;
        }
*/
    }

    if (recorder->is_running) {
        AudioQueueEnqueueBuffer(recorder->audio_queue, buffer,0,NULL);
    } else {
        if (recorder->wavfile) {
            _fclose(recorder->wavfile);
            recorder->wavfile = NULL;
        }
        AudioQueueFreeBuffer(recorder->audio_queue, buffer);
    }

end:
    return;
}


static void
_get_audio_format(AudioStreamBasicDescription *audio_format)
{
    if (audio_format == NULL) {
        goto end;
    }

    audio_format->mFormatID = kAudioFormatLinearPCM;
    audio_format->mSampleRate = AIRECORDER_SAMPLE_RATE;
    audio_format->mChannelsPerFrame = AIRECORDER_CHANNELS;
    audio_format->mBitsPerChannel = AIRECORDER_BITS_PER_SAMPLE;
    audio_format->mFramesPerPacket = 1;
    audio_format->mBytesPerFrame = audio_format->mChannelsPerFrame * audio_format->mBitsPerChannel/8;
    audio_format->mBytesPerPacket = audio_format->mBytesPerFrame * audio_format->mFramesPerPacket;
    audio_format->mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;

end:
    return;
}


static int
_prepare_buffers(AudioQueueRef audio_queue, const AudioStreamBasicDescription *audio_format, int buffer_time)
{
    int rv = -1;

    if (buffer_time > AIRECORDER_CALLBACK_INTERVAL_MAX) {
        buffer_time = AIRECORDER_CALLBACK_INTERVAL_MAX;
    } else if (buffer_time < AIRECORDER_CALLBACK_INTERVAL_MIN) {
        buffer_time = AIRECORDER_CALLBACK_INTERVAL_MIN;
    }

    size_t buffer_size = (size_t)(audio_format->mBytesPerFrame * audio_format->mSampleRate * buffer_time/1000.0);

    AudioQueueBufferRef buffer = NULL;
    for (int i = 0; i<AIRECORDER_BUFFER_NUMBER; ++i) {
        rv = AudioQueueAllocateBuffer(audio_queue, (UInt32)buffer_size, &buffer);
        if (rv != noErr) {
            goto end;
        }
 
        rv = AudioQueueEnqueueBuffer(audio_queue, buffer, 0, NULL);
        if (rv != noErr) {
            goto end;
        }
    }
 
end:
    return rv;
}


struct airecorder *
airecorder_new()
{
    struct airecorder *recorder;
    recorder = (struct airecorder *)calloc(1, sizeof(struct airecorder));
    recorder->player = aiplayer_new();
    return recorder;
}


int airecorder_delete(struct airecorder * recorder)
{
    free(recorder);
    return 0;
}


static void
_reset(struct airecorder *recorder)
{
    if (recorder == NULL) {
        goto end;
    }
    
    if (recorder->audio_queue) {
        AudioQueueDispose(recorder->audio_queue, true); /* queue buffers will also be disposed */
        recorder->audio_queue = NULL;
    }

    if (recorder->wavfile)
    {
        _fclose(recorder->wavfile);
        recorder->wavfile = NULL;
    }

    recorder->is_running = 0;
    recorder->callback = NULL;
    recorder->usrdata = NULL;
    recorder->wavfile = NULL;
    
end:
    return;
}


int
airecorder_start(struct airecorder *recorder, const char* wavpath, airecorder_callback callback, const void* usrdata, int callback_interval)
{
    int rv = -1;
    AudioStreamBasicDescription audio_format;
 
    if (recorder == NULL) {
        goto end;
    }
    
    _reset(recorder);

    strcpy(recorder->wavpath, wavpath);
    recorder->callback = callback;
    recorder->usrdata = usrdata;
    recorder->is_running = 1;

    _get_audio_format(&audio_format);
    recorder->wavfile = _fopen(wavpath);
    
    rv = AudioQueueNewInput(&audio_format, _callback, recorder, NULL, kCFRunLoopCommonModes, 0, &recorder->audio_queue);
    if (rv != noErr) {
        goto end;
    }

    _prepare_buffers(recorder->audio_queue, &audio_format, callback_interval);

    rv = AudioQueueStart(recorder->audio_queue,NULL);
    if (rv != noErr) {
        goto end;
    }

end:
    if (rv != noErr) {
        _reset(recorder);
    }
 
    return rv;
}


int
airecorder_stop(struct airecorder * recorder)
{
    int rv = -1;
    if (recorder == NULL || recorder->is_running == 0) {
        goto end;
    }
    
    recorder->is_running = 0;
    rv = AudioQueueStop(recorder->audio_queue,true);
    if (rv != noErr) {
        goto end;
    }
    
end:
    _reset(recorder);
    return rv;
}


int
airecorder_playback(struct airecorder *recorder)
{
    airecorder_stop(recorder);

    if (!strcmp(recorder->wavpath, "")) {
        goto end;
    }

    aiplayer_start(recorder->player, recorder->wavpath);

end:
    return 0;
}
