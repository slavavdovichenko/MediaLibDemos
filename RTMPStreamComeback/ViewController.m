//
//  ViewController.m
//  RTMPStreamComeback
//
//  Created by Vyacheslav Vdovichenko on 11/13/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"
#import "MemoryTicker.h"
#import "BroadcastStreamClient.h"
#import "MediaStreamPlayer.h"
#import "VideoPlayer.h"


//static NSString *host = @"rtmp://streaming-dev2.affectiva.com:1935/videorecording-dev2";
//static NSString *host = @"rtmp://demo.eudata.biz:1935/wcc";
//static NSString *host = @"rtmp://10.0.1.33:1935/live";
static NSString *host = @"rtmp://192.168.2.63:1935/live";
//static NSString *host = @"rtmp://192.168.2.101:1935/live";
static NSString *stream = @"outgoingaudio_c100"; //@"myStream";

// cross stream mode
static BOOL isCrossStreams = NO;
//static BOOL isCrossStreams = YES;


@interface ViewController () <IMediaStreamEvent> {
    
    MemoryTicker            *memoryTicker;
    
    RTMPClient              *socket;
    BroadcastStreamClient   *upstream;
    MediaStreamPlayer       *player;
    
    int                     upstreamCross;
    int                     downstreamCross;
    
    UIActivityIndicatorView *netActivity;
}

-(void)sizeMemory:(NSNumber *)memory;
-(void)setDisconnect;
@end


@implementation ViewController

#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    memoryTicker = [[MemoryTicker alloc] initWithResponder:self andMethod:@selector(sizeMemory:)];
    memoryTicker.asNumber = YES;
    
    socket = nil;
    upstream = nil;
    player = nil;
    
    upstreamCross = isCrossStreams ? ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 2 : 1) : 0;
    downstreamCross = isCrossStreams ? ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 1 : 2) : 0;
	
	// Create and add the activity indicator
	netActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	netActivity.center = CGPointMake(160.0f, 200.0f);
	[self.view addSubview:netActivity];
    
    // setup the simultaneous record and playback
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
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

// MEMORY

-(void)sizeMemory:(NSNumber *)memory {
    memoryLabel.text = [NSString stringWithFormat:@"%d", [memory intValue]];
}

// ALERT

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self
                                       cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)doConnect {
    
    if (!socket) {
        socket = [[RTMPClient alloc] init:host];
        if (!socket) {
            [self showAlert:@"Socket has not be created"];
            return;
        }
    }
    
    NSString *name = [NSString stringWithFormat:@"%@%d", stream, upstreamCross];
    
    upstream = [[BroadcastStreamClient alloc] initWithClient:socket resolution:RESOLUTION_LOW];
    upstream.delegate = self;
    [upstream stream:name publishType:PUBLISH_LIVE];
        
    [netActivity startAnimating];
    
    btnConnect.title = @"Disconnect";
    streamView.hidden = NO;

}

-(void)doPlay {
    
    NSString *name = [NSString stringWithFormat:@"%@%d", stream, downstreamCross];
    
    FramesPlayer *_player = [[FramesPlayer alloc] initWithView:streamView];
    //_player.orientation = UIImageOrientationRight;
    
    player = [[MediaStreamPlayer alloc] initWithClient:socket];
    player.delegate = self;
    player.player = _player;
    [player stream:name];
    
    btnPublish.title = @"Pause";
    btnToggle.enabled = YES;
}

-(void)doDisconnect {
    [player disconnect];
    [upstream disconnect];
}

-(void)setDisconnect {
    
    NSLog(@" ******************> setDisconnect");
    
    [socket disconnect];
    socket = nil;
  
    player = nil;
    upstream = nil;
    
    [netActivity stopAnimating];
   
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
    
    (streamView.hidden) ? [self doConnect] : [self doDisconnect];
}

-(IBAction)publishControl:(id)sender {
    
    NSLog(@"publishControl: stream = %@", stream);
    
    if (isCrossStreams)
        player ? (player.state != STREAM_PLAYING ? [player start] : [player pause]) : [self doPlay];
    else
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
                
                [self setDisconnect];
                 
                break;
            }
                
            case CONN_CONNECTED: {
                
                if (![description isEqualToString:@"RTMP.Client.isConnected"])
                    break;
                
                [upstream start];
                
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
                
                if (!isCrossStreams)
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
    
    [self setDisconnect];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

@end
