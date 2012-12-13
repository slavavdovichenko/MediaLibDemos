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

#define INITIAL_BUFFER_SIZE 256

@protocol IVideoPlayer;
@class VideoStream, SysTimer, NellyMoserDecoder;

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
    
    // audio stream
    NellyMoserDecoder *audio;
    // video stream
    VideoStream *video;
    
}
@property (nonatomic, assign) id <IMediaStreamEvent> delegate;
@property (nonatomic, retain) id <IVideoPlayer> player;
@property (readonly) MediaStreamState state;

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
