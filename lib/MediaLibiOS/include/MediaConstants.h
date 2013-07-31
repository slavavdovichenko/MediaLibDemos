//
//  MediaConstants.h
//  MediaLibBuilder
//
//  Created by Vyacheslav Vdovichenko on 8/15/11.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

#define MEDIA_CHUNK_SIZE 4096
#define SHOULD_CONNECT @"You should use a valid 'connect', 'attach' or 'stream' method for making the new client connection"
#define SHOULD_DISCONNECT @"You should use 'disconnect' method before making the new client connection"
#define SHOULD_STOP @"You should use 'stop' method before making the new stream"

// is Echo Cancellation needed?
//static BOOL isEchoCancellation = NO;
//static BOOL isEchoCancellation = YES;

typedef enum media_stream_state MediaStreamState;
enum media_stream_state
{
    CONN_DISCONNECTED,
    CONN_CONNECTED,
    STREAM_CREATED,
    STREAM_PLAYING,
    STREAM_PAUSED
};

typedef enum video_encoder_resolution VideoEncoderResolution;
enum video_encoder_resolution
{
    RESOLUTION_LOW,     // 192x144px
    RESOLUTION_CIF,     // 352x288px
    RESOLUTION_MEDIUM,  // 480x360px
    RESOLUTION_VGA,     // 640x480px
    RESOLUTION_HIGH,    // 1280x720px
};

@protocol IMediaStreamEvent <NSObject>
-(void)stateChanged:(id)sender state:(MediaStreamState)state description:(NSString *)description;
-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description;
@optional
-(void)metadataReceived:(id)sender event:(NSString *)event metadata:(NSDictionary *)metadata;
-(void)pixelBufferShouldBePublished:(CVPixelBufferRef)pixelBuffer timestamp:(int)timestamp;
@end
