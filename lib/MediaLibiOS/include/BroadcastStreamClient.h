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

#define kNumberRecordBuffers 3

typedef enum publish_type PublishType;
enum publish_type
{
	PUBLISH_RECORD,
	PUBLISH_APPEND,
	PUBLISH_LIVE,
};

enum video_mode
{
    VIDEO_CAPTURE,
    VIDEO_CUSTOM,
};

enum audio_mode
{
    AUDIO_ON,
    AUDIO_OFF,
};

@protocol IVideoPlayer;
@class VideoEncoder, VideoCodec, AudioCodec, SysTimer;

@interface BroadcastStreamClient : NSObject {
    
    // delegates
    id <IMediaStreamEvent>  delegate;
    id <IVideoPlayer>       player;
    
    // rtmp
    RTMPClient      *socket;
	MediaStreamState state;
	NSString		*_url;
    //
    int streamID;
    int audioChannelID;
    int videoChannelID;
    int commandChannelID;
    int audioTimestamp;
    int videoTimestamp;
    int startTimestamp;
    
    //
    CMTime pts;
    CMTime duration;
    
    // system timer
    SysTimer    *sysTimer;
    
    // media service
    NSString    *fileName;
    PublishType publishType;
    
    // capture session
    AVCaptureSession *captureSession;
    
    // video
	AVCaptureVideoPreviewLayer  *previewLayer;
    VideoEncoderResolution      _resolution;
    //VideoEncoder     *videoEncoder;
    VideoCodec       *videoCodec;
    AVCaptureOutput  *videoOutput;
    CVPixelBufferRef frameBuffer;
	BOOL             isUsingFrontFacingCamera;
    unsigned int     pixelFormatType;
    int              videoMode;
    BOOL             locked;
   
    // audio
    AudioCodec                  *audioCodec;
    // audio queue
    AudioStreamBasicDescription	recordFormat;
    AudioQueueRef				queue;
    AudioQueueBufferRef			buffers[kNumberRecordBuffers];
    int                         audioMode;
    BOOL						isAudioRunning;
}
@property (nonatomic, assign) id <IMediaStreamEvent> delegate;
@property (nonatomic, retain) id <IVideoPlayer> player;
@property MediaStreamState state;
@property BOOL isAudioRunning;

-(id)init:(NSString *)url;
-(id)initWithClient:(RTMPClient *)client;
-(id)init:(NSString *)url resolution:(VideoEncoderResolution)resolution;
-(id)initWithClient:(RTMPClient *)client resolution:(VideoEncoderResolution)resolution;

-(void)setVideoMode:(int)mode;
-(void)setAudioMode:(int)mode;
-(void)setPreviewLayer:(UIView *)preview orientation:(AVCaptureVideoOrientation)orientation;
-(void)teardownPreviewLayer;
-(void)switchCameras;

-(BOOL)connect:(NSString *)url name:(NSString *)name publishType:(PublishType)type;
-(BOOL)attach:(RTMPClient *)client name:(NSString *)name publishType:(PublishType)type;
-(BOOL)stream:(NSString *)name publishType:(PublishType)type;
-(BOOL)sendFrame:(CVPixelBufferRef)pixelBuffer timestamp:(int)timestamp;
-(void)start;
-(void)pause;
-(void)resume;
-(void)stop;
-(void)disconnect;

// for internal usage 
-(void)makeAudioQueue:(AudioQueueBufferRef)sampleBuffer timestamp:(int)timestamp;
@end
