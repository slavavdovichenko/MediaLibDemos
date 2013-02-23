//
//  VideoPlayer.h
//  MediaLibiOS+FFmpeg-09
//
//  Created by Vyacheslav Vdovichenko on 4/28/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoFrameData : NSObject
@property (readonly) uint8_t *data;
@property size_t size;
@property size_t bytesPerRow;
@property size_t width;
@property size_t height;
@property uint   timestamp;
@property uint8_t *baseAddress;

-(id)initWithData:(uint8_t *)_data size:(size_t)_size;
-(id)initWithFrame:(uint8_t *)_data size:(size_t)_size width:(size_t)_width height:(size_t)_height timestamp:(uint)_timestamp;
+(id)videoFrame:(uint8_t *)_data size:(size_t)_size width:(size_t)_width height:(size_t)_height timestamp:(uint)_timestamp;
@end


@protocol IVideoPlayer <NSObject>
-(void)playVideoFrame:(VideoFrameData *)data;
@optional
-(void)playImageBuffer:(CVPixelBufferRef)frameBuffer;
@end


@interface FramesPlayer : NSObject <IVideoPlayer>
@property CGFloat scale;
@property UIImageOrientation orientation;

-(id)initWithView:(UIImageView *)view;
@end;