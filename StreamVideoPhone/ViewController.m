//
//  ViewController.m
//  StreamVideoPhone
//
//  Created by Vyacheslav Vdovichenko on 9/23/13.
//  Copyright (c) 2013 The Midnight Coders, Inc. All rights reserved.
//


#import "ViewController.h"
#import "DEBUG.h"
#import "BroadcastStreamClient.h"
#import "MediaStreamPlayer.h"
#import "VideoPlayer.h"


//static NSString *host = @"rtmp://10.0.1.33:1935/live";
//static NSString *host = @"rtmp://192.168.2.63:1935/live";
//static NSString *host = @"rtmp://192.168.2.101:1935/live";
//static NSString *host = @"rtmp://192.168.1.102:1935/live";
//static NSString *host = @"rtmp://192.168.2.102:1935/live";
static NSString *host = @"rtmp://80.74.155.7/live";

static NSString *stream = @"myStream";


@interface ViewController () <IMediaStreamEvent> {
    
    RTMPClient              *socket;
    BroadcastStreamClient   *upstream;
    MediaStreamPlayer       *player;
    FramesPlayer            *screen;
}

-(void)doConnect;
-(void)doDisconnect;
-(void)setDisconnect;
@end


@implementation ViewController

#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    //[DebLog setIsActive:YES];
    
    [super viewDidLoad];
    
    socket = nil;
    upstream = nil;
    player = nil;
    screen = nil;
    
    //echoCancellationOn;
     
    // setup the simultaneous record and playback
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [self doConnect];    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark Private Methods

// ALERT

-(void)showAlert:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self
                                           cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    });
}

-(void)doConnect {
    
    if (!socket) {
        socket = [[RTMPClient alloc] init:host];
        if (!socket) {
            [self showAlert:@"Socket has not be created"];
            return;
        }
        
        [socket spawnSocketThread];
    }
    
    upstream = [[BroadcastStreamClient alloc] initWithClient:socket resolution:RESOLUTION_LOW];
    //upstream = [[BroadcastStreamClient alloc] initOnlyAudioWithClient:socket];
    //upstream = [[BroadcastStreamClient alloc] initOnlyVideoWithClient:socket resolution:RESOLUTION_LOW];
    
    upstream.delegate = self;
    [upstream stream:stream publishType:PUBLISH_LIVE];
}

-(void)doPlay {
    
    screen = [[FramesPlayer alloc] initWithView:streamView];
    screen.orientation = UIImageOrientationRight;
    
    player = [[MediaStreamPlayer alloc] initWithClient:socket];
    player.delegate = self;
    player.player = screen;
    [player stream:stream];
    
    //[self performSelector:@selector(doDisconnect) withObject:nil afterDelay:5.0f];
}

-(void)doDisconnect {
    [player disconnect];
    [upstream disconnect];
}

-(void)setDisconnect {
    
    NSLog(@" ******************> setDisconnect");
    
    [socket disconnect];
    
    socket = nil;
    screen = nil;
    player = nil;
    upstream = nil;
}

#pragma mark -
#pragma mark IMediaStreamEvent Methods

-(void)stateChanged:(id)sender state:(MediaStreamState)state description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: sender = %@, %d = %@", [sender class], (int)state, description);
    
    if (sender == upstream) {
        
        switch (state) {
                
            case CONN_DISCONNECTED: {
                
                [self setDisconnect];
                break;
            }
                
            case CONN_CONNECTED: {
                
                if (![description isEqualToString:@"RTMP.Client.isConnected"])
                    break;
                
                [upstream start];
                break;
            }
                
            case STREAM_PAUSED: {
                
                if (player)
                    [player pause];
                break;
            }
                
            case STREAM_PLAYING: {
                
                [self doPlay];
                break;
            }
                
            default:
                break;
        }
    }
    
    if (sender == player) {
        
        switch (state) {
                
            case STREAM_CREATED: {
                
                [player start];
                break;
            }
                
            default:
                break;
        }
    }
}

-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> connectFailedEvent: %d = %@\n", code, description);
    
    [self setDisconnect];
    
    [self showAlert:(code == -1) ?
     @"Unable to connect to the server. Make sure the hostname/IP address and port number are valid" :
     [NSString stringWithFormat:@"connectFailedEvent: %@", description]];
}

-(void)metadataReceived:(id)sender event:(NSString *)event metadata:(NSDictionary *)metadata {
    NSLog(@" $$$$$$ <IMediaStreamEvent> dataReceived: EVENT: %@, METADATA = %@", event, metadata);
}

@end
