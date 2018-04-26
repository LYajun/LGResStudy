#include "aiplayer.h"

#include <stdlib.h>

#include "AudioToolbox/AudioToolbox.h"

#define AIPLAYER_BUFFER_NUM    5
#define AIPLAYER_BUFFER_DURATION 0.5

struct aiplayer {
    CFStringRef                  file_path;
    AudioQueueRef                queue;
    AudioQueueBufferRef          buffers[AIPLAYER_BUFFER_NUM];
    AudioStreamBasicDescription  audio_format;
    AudioFileID                  audio_file;
    UInt32                       num_packets_to_read;
    SInt64                       current_packet; // current packet number in audio file
    Boolean                      is_playing;
    Boolean                      is_done;
    Boolean                      is_looping;

    /*
    aiplayer_stopped_callback_func fn_stopped;
    const void *                   fn_stopped_user_data;
    */
};


static void
_enqueue_callback(void * usrdata, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer)
{
    struct aiplayer *player = (struct aiplayer *)usrdata;

    if (player->is_done) {
        return;
    }

    UInt32 numBytes;
    UInt32 nPackets = player->num_packets_to_read;
    int result = AudioFileReadPackets(player->audio_file, false, &numBytes, inCompleteAQBuffer->mPacketDescriptions, player->current_packet, &nPackets,
                                           inCompleteAQBuffer->mAudioData);

    if (result)
        printf("AudioFileReadPackets failed: %d", (int)result);
    if (nPackets > 0) {
        inCompleteAQBuffer->mAudioDataByteSize = numBytes;
        inCompleteAQBuffer->mPacketDescriptionCount = nPackets;
        AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL);
        player->current_packet = (player->current_packet + nPackets);
    }
    else
    {
        if (player->is_looping)
        {
            player->current_packet = 0;
            _enqueue_callback(usrdata, inAQ, inCompleteAQBuffer);
        }
        else
        {
            // stop
            player->is_done = true;
            AudioQueueStop(inAQ, false);
        }
    }
}


static void
_running_callback(void * usrdata, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
    struct aiplayer *player = (struct aiplayer *)usrdata;
    UInt32 size = sizeof(UInt32);
    int result = AudioQueueGetProperty (inAQ, kAudioQueueProperty_IsRunning, &player->is_playing, &size);

    if ((result == noErr) && (!player->is_playing)){
        /*
        if (player->fn_stopped){
            player->fn_stopped(player->fn_stopped_user_data);
        }
        */
        aiplayer_stop(player); /* stop automatically */
    }
}


static void
 _calc_bytes_for_time(AudioStreamBasicDescription inDesc, UInt32 inMaxPacketSize, Float64 inSeconds, UInt32 *outBufferSize, UInt32 *outNumPackets)
{
    // we only use time here as a guideline
    // we're really trying to get somewhere between 16K and 64K buffers, but not allocate too much if we don't need it
    static const int maxBufferSize = 0x10000; // limit size to 64K
    static const int minBufferSize = 0x4000; // limit size to 16K

    if (inDesc.mFramesPerPacket) {
        Float64 numPacketsForTime = inDesc.mSampleRate / inDesc.mFramesPerPacket * inSeconds;
        *outBufferSize = numPacketsForTime * inMaxPacketSize;
    } else {
        // if frames per packet is zero, then the codec has no predictable packet == time
        // so we can't tailor this (we don't know how many Packets represent a time period
        // we'll just return a default buffer size
        *outBufferSize = maxBufferSize > inMaxPacketSize ? maxBufferSize : inMaxPacketSize;
    }

    // we're going to limit our size to our default
    if (*outBufferSize > maxBufferSize && *outBufferSize > inMaxPacketSize)
        *outBufferSize = maxBufferSize;
    else {
        // also make sure we're not too small - we don't want to go the disk for too small chunks
        if (*outBufferSize < minBufferSize)
            *outBufferSize = minBufferSize;
    }
    *outNumPackets = *outBufferSize / inMaxPacketSize;
}


static void
_setup_new_queue(struct aiplayer *player)
{
    /* CFRunLoopGetCurrent() */
    if (AudioQueueNewOutput( &player->audio_format, _enqueue_callback, player, NULL, kCFRunLoopCommonModes, 0, &player->queue) != noErr){
        printf("AudioQueueNew failed\n");
        return;
    }

    UInt32 bufferByteSize;
    // we need to calculate how many packets we read at a time, and how big a buffer we need
    // we base this on the size of the packets in the file and an approximate duration for each buffer
    // first check to see what the max size of a packet is - if it is bigger
    // than our allocation default size, that needs to become larger
    UInt32 maxPacketSize;
    UInt32 size = sizeof(maxPacketSize);
    if (AudioFileGetProperty(
                             player->audio_file,
                             kAudioFilePropertyPacketSizeUpperBound,
                             &size,
                             &maxPacketSize
                             ) != noErr){
        printf("couldn't get file's max packet size");
        return;
    }
    
    // adjust buffer size to represent about a half second of audio based on this format
    _calc_bytes_for_time(player->audio_format, maxPacketSize, AIPLAYER_BUFFER_DURATION, &bufferByteSize, &player->num_packets_to_read);
    
    //printf ("Buffer Byte Size: %d, Num Packets to Read: %d\n", (int)bufferByteSize, (int)mNumPacketsToRead);
    
    // (2) If the file has a cookie, we should get it and set it on the AQ
    size = sizeof(UInt32);
    int result = AudioFileGetPropertyInfo (player->audio_file, kAudioFilePropertyMagicCookieData, &size, NULL);
    
    if (!result && size) {
        char* cookie = (char *) malloc (size);
        if (AudioFileGetProperty (player->audio_file, kAudioFilePropertyMagicCookieData, &size, cookie) != noErr){
            printf("get cookie from file");
            return;
        }
        if (AudioQueueSetProperty(player->queue, kAudioQueueProperty_MagicCookie, cookie, size) != noErr){
            printf("set cookie on queue");
            return;
        }
        free(cookie);
    }
    
    // channel layout?
    result = AudioFileGetPropertyInfo(player->audio_file, kAudioFilePropertyChannelLayout, &size, NULL);
    if (result == noErr && size > 0) {
        AudioChannelLayout *acl = (AudioChannelLayout *)malloc(size);
        if (AudioFileGetProperty(player->audio_file, kAudioFilePropertyChannelLayout, &size, acl) != noErr)
            printf("ERROR: get audio file's channel layout");
        if (AudioQueueSetProperty(player->queue, kAudioQueueProperty_ChannelLayout, acl, size) != noErr)
            printf("ERROR: set channel layout on queue");
        free(acl);
    }
    
    if (AudioQueueAddPropertyListener(player->queue, kAudioQueueProperty_IsRunning, _running_callback, player) != noErr)
        printf("ERROR: adding property listener");
    
    bool isFormatVBR = (player->audio_format.mBytesPerPacket == 0 || player->audio_format.mFramesPerPacket == 0);
    for (int i = 0; i < AIPLAYER_BUFFER_NUM; ++i) {
        if (AudioQueueAllocateBufferWithPacketDescriptions(
                                                           player->queue,
                                                           bufferByteSize,
                                                           (isFormatVBR ? player->num_packets_to_read : 0),
                                                           &player->buffers[i]
                                                           ) != noErr)
            printf("ERROR: AudioQueueAllocateBuffer failed");
    }
    
    // set the volume of the queue
    if (AudioQueueSetParameter(player->queue, kAudioQueueParam_Volume, 1.0) != noErr)
        printf("ERROR: set queue volume");
}


static int
_create_queue(struct aiplayer *player, CFStringRef inFilePath)
{
    CFURLRef sndFile = NULL;

    if (player->file_path == NULL)
    {
        player->is_looping = false;

        sndFile = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, inFilePath, kCFURLPOSIXPathStyle, false);
        if (!sndFile) { printf("can't parse file path\n"); return -1;}

        if (AudioFileOpenURL (sndFile, kAudioFileReadPermission, 0/*inFileTypeHint*/, &player->audio_file) != noErr)
        printf("can't open file");

        UInt32 size = sizeof(player->audio_format);
        if (AudioFileGetProperty(
            player->audio_file,
            kAudioFilePropertyDataFormat,
            &size,
            &player->audio_format) != noErr)
        printf("couldn't get file's data format");

        player->file_path = CFStringCreateCopy(kCFAllocatorDefault, inFilePath);
    }

    _setup_new_queue(player);

    if (sndFile)
        CFRelease(sndFile);

    return 0;
}


static int
_start_queue(struct aiplayer *player, Boolean inResume/*, aiplayer_stopped_callback_func fn_stopped, const void *fn_stopped_user_data*/)
{
    // if we have a file but no queue, create one now
    if ((player->queue == NULL) && (player->file_path != NULL))
        _create_queue(player, player->file_path);

    /*
    player->fn_stopped = fn_stopped;
    player->fn_stopped_user_data = fn_stopped_user_data;
    */
    player->is_done = false;

    // if we are not resuming, we also should restart the file read index
    if (!inResume)
        player->current_packet = 0;

    // prime the queue with some data before starting
    if (player->queue != NULL) {
        for (int i = 0; i < AIPLAYER_BUFFER_NUM; ++i) {
            _enqueue_callback(player, player->queue, player->buffers[i]);
        }
    }
    UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
    return AudioQueueStart(player->queue, NULL);
}


static void
_dispose_queue(struct aiplayer *player, Boolean inDisposeFile)
{
    if (player->queue){
        AudioQueueDispose(player->queue, true);
        player->queue = NULL;
    }
    if (inDisposeFile){
        if (player->audio_file)
        {
            AudioFileClose(player->audio_file);
            player->audio_file = 0;
        }
        if (player->file_path)
        {
            CFRelease(player->file_path);
            player->file_path = NULL;
        }
    }
}


static int
_stop_queue(struct aiplayer *player)
{
    int rv;
    rv = AudioQueueStop(player->queue, true);
    _dispose_queue(player, true);
    return rv;
}


static int
_pause_queue(struct aiplayer *player)
{
    int result = AudioQueuePause(player->queue);
    return result;
}


struct aiplayer *
aiplayer_new()
{
    struct aiplayer *player = NULL;

    player = (struct aiplayer *)calloc(1, sizeof(struct aiplayer));

    player->is_playing = false;
    player->is_done = false;
    player->is_looping = false;
    player->num_packets_to_read = 0;
    player->current_packet = 0;
    player->audio_file = 0;
    player->file_path = NULL;

    return player;
}


int
aiplayer_delete(struct aiplayer *player)
{
    /*
    player->fn_stopped = NULL;
    player->fn_stopped_user_data = NULL;
    */
    _dispose_queue(player, true);

    free(player);

    return 0;
}


int
aiplayer_start(struct aiplayer *player, const char *path)
{
    int rv;
    CFStringRef pathref = NULL;

    pathref = CFStringCreateWithCString(NULL, path, kCFStringEncodingASCII);
    rv = _create_queue(player, pathref);
    rv = _start_queue(player, 0);

    return rv;
}


int
aiplayer_stop(struct aiplayer *player)
{
    return _stop_queue(player);
}
