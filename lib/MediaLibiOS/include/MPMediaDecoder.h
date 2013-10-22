//
//  StreamReader.h
//  ChattrSpace
//
//  Created by Greg Hookey on 12-07-14.
//  Copyright (c) 2012 DeadlySoft. All rights reserved.
//


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#define UIImage NSImage
#endif
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@class AudioQueuePlayer;

@interface MPMediaDecoder : NSThread {
    
    uint8_t _videoBuffer[700000];
    size_t _videoBufferSize;
    CMTime _videoDuration;
    CMTime _videoPTS;
    
    uint8_t _audioBuffer[700000];
    size_t _audioBufferSize;
    CMTime _audioPTS;
    
    BOOL _quit;
    
    UIImageView *_streamImageView;
    AudioQueuePlayer *_audioQueuePlayer;
}

- (int)openStream;
- (int)setupStreamReader;
- (void)cleanupStreamReader;
- (void)readerQuit;

- (void)setStreamImageView:(UIImageView *)streamImageView;

@end
