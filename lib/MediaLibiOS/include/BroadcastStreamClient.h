//
//  BroadcastStreamClient.h
//  RTMPStream
//
//  Created by Vyacheslav Vdovichenko on 8/15/11.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import "MediaConstants.h"
#import "RTMPClient.h"

typedef enum publish_type PublishType;
enum publish_type
{
	PUBLISH_RECORD,
	PUBLISH_APPEND,
	PUBLISH_LIVE,
};

typedef enum video_mode VideoMode;
enum video_mode
{
    VIDEO_CAPTURE,
    VIDEO_CUSTOM,
};

typedef enum audio_mode AudioMode;
enum audio_mode
{
    AUDIO_ON,
    AUDIO_OFF,
};

@protocol IVideoPlayer;
@class VideoEncoder, VideoCodec, AudioCodec, SysTimer;

@interface BroadcastStreamClient : NSObject 

@property (nonatomic, assign) id <IMediaStreamEvent> delegate;
@property (nonatomic, retain) id <IVideoPlayer> player;
@property (nonatomic, retain) NSArray *parameters;
@property (nonatomic, retain) NSString *customType;
@property MediaStreamState state;
@property BOOL isAudioRunning;
@property BOOL isUsingFrontFacingCamera;

-(id)init:(NSString *)url;
-(id)initWithClient:(RTMPClient *)client;
-(id)init:(NSString *)url resolution:(VideoEncoderResolution)resolution;
-(id)initWithClient:(RTMPClient *)client resolution:(VideoEncoderResolution)resolution;
-(id)initOnlyAudio:(NSString *)url;
-(id)initOnlyAudioWithClient:(RTMPClient *)client;
-(id)initOnlyVideo:(NSString *)url resolution:(VideoEncoderResolution)resolution;
-(id)initOnlyVideoWithClient:(RTMPClient *)client resolution:(VideoEncoderResolution)resolution;

-(BOOL)setVideoMode:(VideoMode)mode;
-(void)setVideoResolution:(VideoEncoderResolution)resolution;
-(void)setVideoBitrate:(uint)bitRate;
-(void)setVideoResolution:(VideoEncoderResolution)resolution bitRate:(uint)bitRate;
-(void)setVideoOrientation:(AVCaptureVideoOrientation)orientation;
-(void)setPreviewLayer:(UIView *)preview;
-(void)teardownPreviewLayer;
-(void)switchCameras;
-(AVCaptureSession *)getCaptureSession;

-(BOOL)setAudioMode:(AudioMode)mode;
-(void)setAudioPickingSeconds:(float)seconds;
-(void)setAudioBitrate:(uint)bitRate;

-(BOOL)connect:(NSString *)url name:(NSString *)name publishType:(PublishType)type;
-(BOOL)attach:(RTMPClient *)client name:(NSString *)name publishType:(PublishType)type;
-(BOOL)stream:(NSString *)name publishType:(PublishType)type;
-(BOOL)sendFrame:(CVPixelBufferRef)pixelBuffer timestamp:(int)timestamp;
-(void)sendMetadata:(NSDictionary *)data;
-(void)start;
-(void)pause;
-(void)resume;
-(void)stop;
-(void)disconnect;

// for internal usage 
-(void)makeAudioQueue:(AudioQueueBufferRef)sampleBuffer timestamp:(int)timestamp;
@end
