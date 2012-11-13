//
//  ViewController.m
//  RTMPStreamComeback
//
//  Created by Vyacheslav Vdovichenko on 11/13/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"
#import "VideoPlayer.h"


static NSString *host = @"rtmp://demo.eudata.biz:1935/live";
static NSString *stream = @"myStream";


@implementation ViewController

#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    client = nil;
    upstream = nil;
    player = nil;
    
    // setup the simultaneous record and playback
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    //[DebLog setIsActive:YES];
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

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self
                                       cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)doConnect {
    
    client = [[RTMPClient alloc] init:host];
    upstream = [[BroadcastStreamClient alloc] initWithClient:client resolution:RESOLUTION_LOW];
    //[upstream setAudioMode:AUDIO_OFF];
    [upstream setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [upstream setPreviewLayer:previewView];
    //
    upstream.delegate = self;
    [upstream stream:stream publishType:PUBLISH_LIVE];
    
    btnConnect.title = @"Disconnect";
}

-(void)doPlay {
    
    FramesPlayer *_player = [[FramesPlayer alloc] initWithView:streamView];
    _player.orientation = UIImageOrientationRight;
    
    player = [[MediaStreamPlayer alloc] initWithClient:client];
    player.delegate = self;
    player.player = _player;
    [player stream:stream];
}

-(void)doDisconnect {
    
    [upstream disconnect];
    upstream = nil;
    player = nil;
    client = nil;
    
    btnConnect.title = @"Connect";
    btnToggle.enabled = NO;
    btnPublish.title = @"Start";
    btnPublish.enabled = NO;
    
    previewView.hidden = YES;
    streamView.hidden = YES;
    
}

#pragma mark -
#pragma mark Public Methods

// ACTIONS

-(IBAction)connectControl:(id)sender {
    
    NSLog(@"connectControl: host = %@", host);
    
    (!upstream) ? [self doConnect] : [self doDisconnect];
}

-(IBAction)publishControl:(id)sender {
    
    NSLog(@"publishControl: stream = %@", stream);
    
    (upstream.state != STREAM_PLAYING) ? [upstream start] : [upstream pause];
}

-(IBAction)camerasToggle:(id)sender {
    
    NSLog(@"camerasToggle:");
    
    if (upstream.state == STREAM_PLAYING)
        [upstream switchCameras];
    
}

#pragma mark -
#pragma mark IMediaStreamEvent Methods

-(void)stateChanged:(id)sender state:(MediaStreamState)state description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: %d = %@", (int)state, description);
    
    if (sender == upstream) {
        
        switch (state) {
                
            case CONN_DISCONNECTED: {
                
                [self doDisconnect];
                [self showAlert:[NSString stringWithString:description]];
                
                break;
            }
                
            case CONN_CONNECTED: {
                
                if (![description isEqualToString:@"RTMP.Client.isConnected"])
                    break;
                
                [self publishControl:nil];
                
                previewView.hidden = NO;
                btnPublish.enabled = YES;
                
                break;
                
            }
                
            case STREAM_PAUSED: {
                
                btnPublish.title = @"Start";
                btnToggle.enabled = NO;
                
                break;
            }
                
            case STREAM_PLAYING: {
                
                [self doPlay];
                
                btnPublish.title = @"Pause";
                btnToggle.enabled = YES;
                
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
                
                streamView.hidden = NO;
                
                break;
                
            }
                
            default:
                break;
        }
    }
}

-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> connectFailedEvent: %d = %@\n", code, description);
    
    if (sender != upstream)
        return;
    
    [self doDisconnect];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

@end
