//
//  MediaConstants.h
//  MediaLibBuilder
//
//  Created by Vyacheslav Vdovichenko on 8/15/11.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MEDIA_CHUNK_SIZE 4096
#define SHOULD_CONNECT @"You should use a valid 'connect' method to connect the client"
#define SHOULD_DISCONNECT @"You should use 'disconnect' method before making the new client connection"

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
    RESOLUTION_MEDIUM,  // 480x360px
    RESOLUTION_VGA,     // 640x480px
    RESOLUTION_HIGH,    // 1280x720px
};

@protocol IMediaStreamEvent <NSObject>
-(void)stateChanged:(MediaStreamState)state description:(NSString *)description;
-(void)connectFailed:(int)code description:(NSString *)description;
@end
