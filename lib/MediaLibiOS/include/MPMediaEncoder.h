//
//  MPMediaEncoder.h
//  RTMPStream
//
//  Created by Vyacheslav Vdovichenko on 9/30/13.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import "MPMediaData.h"

@interface MPMediaEncoder : NSObject <MPIMediaEncoder>
@property MPVideoResolution resolution;
@property uint bitRate;
@end
