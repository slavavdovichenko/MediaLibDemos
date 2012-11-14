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
    
    upstream = nil;
    player = nil;
	
	// Create and add the activity indicator
	netActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	netActivity.center = CGPointMake(160.0f, 200.0f);
	[self.view addSubview:netActivity];
    
    // setup the simultaneous record and playback
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    [DebLog setIsActive:YES];
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
    
    upstream = [[BroadcastStreamClient alloc] init:host resolution:RESOLUTION_LOW];
    [upstream setVideoOrientation:AVCaptureVideoOrientationPortrait];
    upstream.delegate = self;
    [upstream stream:stream publishType:PUBLISH_LIVE];
    
    [netActivity startAnimating];
    
    btnConnect.title = @"Disconnect";
}

-(void)doPlay {
    
    if (player) {
        [player resume];
        return;
    }
    
    [self camerasToggle:nil];
    
    FramesPlayer *_player = [[FramesPlayer alloc] initWithView:streamView];
    _player.orientation = UIImageOrientationRight;
    
    player = [[MediaStreamPlayer alloc] init:host];
    player.delegate = self;
    player.player = _player;
    [player stream:stream];
}

-(void)doDisconnect {
    
    if (upstream)
        [upstream disconnect];
    if (player)
        [player disconnect];
    
    upstream = nil;
    player = nil;
    
    btnConnect.title = @"Connect";
    btnToggle.enabled = NO;
    btnPublish.title = @"Start";
    btnPublish.enabled = NO;
    
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
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: sender = %@, %d = %@", [sender class], (int)state, description);
    
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
                
                btnPublish.enabled = YES;
                
                break;
            }
                
            case STREAM_PAUSED: {
                
                if (player)
                    [player pause];
                
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
                
                [netActivity stopAnimating];
                
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
    
    [self doDisconnect];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

@end
