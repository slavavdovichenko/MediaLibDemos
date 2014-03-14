//
//  MPMediaData.h
//  MediaLibiOS
//
//  Created by Vyacheslav Vdovichenko on 10/3/13.
//  Copyright (c) 2013 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

#define RESOLUTION_HIGH_ON 0

#define MP_RTMP_CLIENT_IS_CONNECTED @"RTMP.Client.isConnected"
#define MP_NETSTREAM_PLAY_STREAM_NOT_FOUND @"NetStream.Play.StreamNotFound"
#define MP_STREAM_SHOULD_VALID_CONNECT @"You should use a valid 'connect', 'attach' or 'stream' method for making the new stream"
#define MP_STREAM_SHOULD_DISCONNECT @"You should use 'disconnect' method before making the new stream"
#define MP_STREAM_SHOULD_STOP @"You should use 'stop' method before making the new stream"

typedef enum mp_media_channel_id MPMediaChannelID;
enum mp_media_channel_id
{
    SYSTEM_CHANNEL_ID = 3,
    AUDIO_CHANNEL_ID = 4,
    VIDEO_CHANNEL_ID = 6,
    COMMAND_CHANNEL_ID = 8,
};


typedef enum mp_media_stream_state MPMediaStreamState;
enum mp_media_stream_state
{
    CONN_DISCONNECTED,
    CONN_CONNECTED,
    STREAM_CREATED,
    STREAM_PLAYING,
    STREAM_PAUSED,
};

typedef enum video_encoder_resolution MPVideoResolution;
enum video_encoder_resolution
{
    RESOLUTION_LOW,     // 192x144px
    RESOLUTION_CIF,     // 352x288px
    RESOLUTION_MEDIUM,  // 480x360px
    RESOLUTION_VGA,     // 640x480px
#if RESOLUTION_HIGH_ON
    RESOLUTION_HIGH,    // 1280x720px
#endif
};

typedef enum mp_publish_type MPMediaPublishType;
enum mp_publish_type
{
	PUBLISH_RECORD,
	PUBLISH_APPEND,
	PUBLISH_LIVE,
};

typedef enum mp_audio_pcm_type MPAudioPCMType;
enum mp_audio_pcm_type
{
	MP_AUDIO_PCM_S16,
	MP_AUDIO_PCM_FLT,
};

@interface MPMediaData : NSObject
@property uint8_t *data;
@property size_t size;
@property size_t width;
@property size_t height;
@property size_t bytesPerRow;
@property uint timestamp;
@property uint type;
@property CMTime pts;
@property CMTime duration;
@property (retain) id content;

-(id)initWithData:(uint8_t *)data size:(size_t)size timestamp:(uint)timestamp;
+(BOOL)setAudioStreamBasicDescription:(AudioStreamBasicDescription *)streamDescription pcmType:(MPAudioPCMType)pcmType;
@end

@protocol MPIMediaStream <NSObject>
-(NSString *)getMediaStreamUrl;
-(void)sendMediaFrame:(MPMediaData *)data;
@end

@protocol MPIMediaStreamEvent <NSObject>
-(void)stateChanged:(id)sender state:(MPMediaStreamState)state description:(NSString *)description;
-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description;
@optional
-(void)metadataReceived:(id)sender event:(NSString *)event metadata:(NSDictionary *)metadata;
-(void)pixelBufferShouldBePublished:(CVPixelBufferRef)pixelBuffer timestamp:(int)timestamp;
@end

@protocol MPIMediaEncoder <NSObject>
-(int)setupStream:(id)stream;
-(void)cleanupStream;
-(BOOL)addVideoFrame:(uint8_t *)data dataSize:(size_t)size pts:(CMTime)pts duration:(CMTime)duration;
-(BOOL)addAudioSamples:(uint8_t *)data dataSize:(size_t)size pts:(CMTime)pts;
@end

