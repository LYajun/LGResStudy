//
//  KYRecorder.m
//  KouyuDemo
//
//  Created by Attu on 2017/12/26.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "KYRecorder.h"
#import "KYPlayer.h"
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioConverter.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "KYWavHeader.h"

#define KYRECORDER_BUFFER_NUMBER 5
#define KYRECORDER_CALLBACK_INTERVAL_MAX 1000  // 1000ms
#define KYRECORDER_CALLBACK_INTERVAL_MIN 50    // 50ms

#define KYRECORDER_SAMPLERATE 16000
#define KYRECORDER_CHANNELS 1
#define KYRECORDER_BITS_PER_SAMPLE 16

@interface KYRecorder ()

@property (nonatomic, strong) KYPlayer *player;
@property (nonatomic, assign) AudioQueueRef audioQueue;
@property (nonatomic, copy) NSString *wavPath;
@property (nonatomic, copy) KYRecorderBlock recorderBlock;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) struct skegn *engine;

@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation KYRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        self.player = [[KYPlayer alloc] init];
    }
    return self;
}

- (int)startReocrdWith:(NSString *)wavPath engine:(struct skegn *)engine callbackInterval:(NSInteger)interval recorderBlock:(KYRecorderBlock)recorderBlock {
    int rv = -1;
    
    AudioStreamBasicDescription audioFormat = [self configAudioFormat];
    
    [self resetRecorder];
    
    self.wavPath = wavPath;
    self.recorderBlock = recorderBlock;
    self.engine = engine;
    self.isRunning = YES;
    
    [self openFileWith:wavPath];
    
    rv = AudioQueueNewInput(&audioFormat, audioQueueCallback, (__bridge void * _Nullable)(self), NULL, kCFRunLoopCommonModes, 0, &_audioQueue);
    if (rv != noErr) {
        return rv;
    }
    
    [self prepareBuffers:audioFormat bufferInterval:interval];
    rv = AudioQueueStart(self.audioQueue, NULL);

    return rv;
}

- (void)stopRecorder {
    
    if (!self.isRunning) {
        [self resetRecorder];
    }
    
    self.isRunning = NO;
    AudioQueueStop(self.audioQueue, true);
    
    [self resetRecorder];
}

- (void)playback {
    [self.player playWithPath:self.wavPath];
}

#pragma mark - Private Method

- (void)openFileWith:(NSString *)filePath {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];

    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    WavHeader header;

    int sample_rate = KYRECORDER_SAMPLERATE;
    int channels = KYRECORDER_CHANNELS;
    int bits_per_sample = KYRECORDER_BITS_PER_SAMPLE;

    strncpy(header.riff, "RIFF", 4);
    header.riff_length = 0;
    strncpy(header.riff_type, "WAVE", 4);
    strncpy(header.fmt, "fmt ", 4);
    header.fmt_size = 16;
    header.fmt_code = 1;
    header.fmt_channel = channels;
    header.fmt_sampleRate = sample_rate;
    header.fmt_bytePerSec = sample_rate * bits_per_sample * channels / 8;
    header.fmt_blockAlign = bits_per_sample * channels / 8;
    header.fmt_bitPerSample = bits_per_sample;
    strncpy(header.data, "data", 4);
    header.dataSize = 0;

    NSData *data = [NSData dataWithBytes:&header length:44];

    [self.fileHandle writeData:data];
}

- (void)resetRecorder {
    if (self.audioQueue) {
        AudioQueueDispose(self.audioQueue, true);
        self.audioQueue = nil;
    }
    if (self.fileHandle) {
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    
    self.isRunning = NO;
    self.recorderBlock = nil;
    self.engine = nil;
}

- (AudioStreamBasicDescription)configAudioFormat {
    AudioStreamBasicDescription audioFormat;
    
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mSampleRate = KYRECORDER_SAMPLERATE;
    audioFormat.mChannelsPerFrame = KYRECORDER_CHANNELS;
    audioFormat.mBitsPerChannel = KYRECORDER_BITS_PER_SAMPLE;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerFrame = audioFormat.mChannelsPerFrame * audioFormat.mBitsPerChannel/8;
    audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    return audioFormat;
}

static void audioQueueCallback(void * userdata, AudioQueueRef audioQueue, AudioQueueBufferRef buffer, const AudioTimeStamp *startTime, UInt32 packetNum, const AudioStreamPacketDescription *packetDesc) {
    
    KYRecorder *recorder = (__bridge KYRecorder *)userdata;
    
    if (buffer->mAudioDataByteSize > 0) {
        if (recorder.recorderBlock) {
            recorder.recorderBlock(recorder.engine, buffer->mAudioData, buffer->mAudioDataByteSize);
        }
        
        [recorder.fileHandle seekToEndOfFile];
        NSData *data = [NSData dataWithBytes:buffer->mAudioData length:buffer->mAudioDataByteSize];
        [recorder.fileHandle writeData:data];
    }
    
    if (recorder.isRunning) {
        AudioQueueEnqueueBuffer(recorder.audioQueue, buffer, 0, NULL);
    } else {
        if (recorder.fileHandle) {
            
            NSInteger fileSize = 0;
            NSInteger riffDataSize = 0;
            NSInteger dataSize = 0;
            
            fileSize = [[recorder.fileHandle readDataToEndOfFile] length];
            riffDataSize = fileSize - 4;
            dataSize = fileSize - 44;
            
            [recorder.fileHandle seekToFileOffset:4];
            [recorder.fileHandle writeData:[NSData dataWithBytes:&riffDataSize length:4]];
            
            [recorder.fileHandle seekToFileOffset:40];
            [recorder.fileHandle writeData:[NSData dataWithBytes:&dataSize length:4]];
            
            [recorder.fileHandle closeFile];
            recorder.fileHandle = nil;

        }
        AudioQueueFreeBuffer(recorder.audioQueue, buffer);
    }
}

- (void)prepareBuffers:(const AudioStreamBasicDescription)audioFormat bufferInterval:(NSInteger)bufferInterval {
    if (bufferInterval > KYRECORDER_CALLBACK_INTERVAL_MAX) {
        bufferInterval = KYRECORDER_CALLBACK_INTERVAL_MAX;
    } else if (bufferInterval < KYRECORDER_CALLBACK_INTERVAL_MIN) {
        bufferInterval = KYRECORDER_CALLBACK_INTERVAL_MIN;
    }
    
    UInt32 buffer_size = (UInt32)(audioFormat.mBytesPerFrame * audioFormat.mSampleRate * bufferInterval/1000.0);
    
    AudioQueueBufferRef buffer = NULL;
    for (int i = 0; i<KYRECORDER_BUFFER_NUMBER; ++i) {
        int rv = AudioQueueAllocateBuffer(self.audioQueue, buffer_size, &buffer);
        if (rv != noErr) {
            return;
        }
        
        rv = AudioQueueEnqueueBuffer(self.audioQueue, buffer, 0, NULL);
        if (rv != noErr) {
            return;
        }
    }
}

@end
