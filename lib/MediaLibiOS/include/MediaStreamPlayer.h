//
//  MediaStreamPlayer.h
//  RTMPStream
//
//  Created by Vyacheslav Vdovichenko on 9/18/11.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaConstants.h"
#import "RTMPClient.h"

#define INITIAL_BUFFER_SIZE 2500

@protocol IVideoPlayer;
@class AudioStream, VideoStream, SysTimer;

@interface MediaStreamPlayer : NSObject {
	
    // delegate
	id <IMediaStreamEvent>  delegate;
    id <IVideoPlayer>       player;
    
    // rtmp
    RTMPClient	*socket;
    MediaStreamState state;
	NSString	*_url;
    //
    int         streamID;
    
    // stream options
    NSString    *streamName;
    int         timestamp;
    int         start;
    int         duration;
    BOOL        reset;
    
    //
    SysTimer    *sysTimer;
    
    // audio & video synchronization
    NSMutableArray *pendingFrames;
    BOOL        isSynchronization;
    int         audioLastTimer;
    int         videolastTimer;
    int         audioTimestamp;
    int         videoTimestamp;
    
    // audio stream
    AudioStream *audio;
    // video stream
    VideoStream *video;
    
}
@property (nonatomic, assign) id <IMediaStreamEvent> delegate;
@property (nonatomic, retain) id <IVideoPlayer> player;
@property (readonly) MediaStreamState state;
@property BOOL isSynchronization;

-(id)init:(NSString *)url;
-(id)initWithClient:(RTMPClient *)client;

-(BOOL)connect:(NSString *)url name:(NSString *)name;
-(BOOL)attach:(RTMPClient *)client name:(NSString *)name;
-(BOOL)stream:(NSString *)name;
-(BOOL)isPlaying;
-(BOOL)start;
-(void)pause;
-(void)resume;
-(BOOL)stop;
-(void)disconnect;
@end
