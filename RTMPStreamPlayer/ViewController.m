//
//  ViewController.m
//  RTMPStreamPlayer
//
//  Created by Vyacheslav Vdovichenko on 7/11/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"
#import "MemoryTicker.h"
#import "MediaStreamPlayer.h"
#import "VideoPlayer.h"


@interface ViewController () <IMediaStreamEvent> {
    MemoryTicker            *memoryTicker;
    RTMPClient              *socket;
    MediaStreamPlayer       *player;
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
    
    player = nil;
    socket = nil;
    
    echoCancellationOn;
    
    //hostTextField.text = @"rtmp://10.0.1.33:1935/live";
    //hostTextField.text = @"rtmp://10.0.1.33:1935/vod";
    //hostTextField.text = @"rtmp://10.0.2.34:1935/mediaAppDummy";
    //hostTextField.text = @"rtmp://10.0.1.132:1935/mediaAppDummy";
    //hostTextField.text = @"rtmp://192.168.2.101:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.63:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.63:1935/vod";
    //hostTextField.text = @"rtmp://demo.eudata.biz:1935/wcc";
    //hostTextField.text = @"rtmp://demo.eudata.biz:1936/wcc";
    hostTextField.text = @"rtmp://192.168.1.100:1935/live";
    //hostTextField.text = @"rtmp://streaming-dev2.affectiva.com:1935/videorecording-dev2";
    hostTextField.delegate = self;
    
    //streamTextField.text = @"outgoingaudio_c109";
    streamTextField.text = @"myStream";
	streamTextField.delegate = self;
    
    //[DebLog setIsActive:YES];
    
}

-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    FramesPlayer *framesPlayer = [[FramesPlayer alloc] initWithView:previewView];
    //framesPlayer.orientation = UIImageOrientationRight;
    
    player = [[MediaStreamPlayer alloc] init:hostTextField.text];
    
    /*/
    if (!socket) {
        socket = [[RTMPClient alloc] init:hostTextField.text];
        if (!socket) {
            [self showAlert:@"Socket has not be created"];
            return;
        }
    }
    player = [[MediaStreamPlayer alloc] initWithClient:socket];
    /*/
    
    player.delegate = self;
    player.player =framesPlayer;
    [player stream:streamTextField.text];    
    
    btnConnect.title = @"Disconnect"; 
}

-(void)doDisconnect {
    [player disconnect];
}

-(void)setDisconnect {
    
    /*/
    [socket disconnect];
    socket = nil;
    /*/

    player = nil;
    
    btnConnect.title = @"Connect";
    btnPlay.title = @"Start";
    btnPlay.enabled = NO;
    
    hostTextField.hidden = NO;
    streamTextField.hidden = NO;
    
    previewView.hidden = YES;
    
}

#pragma mark -
#pragma mark Public Methods 

// ACTIONS

-(IBAction)connectControl:(id)sender {
    
    NSLog(@"******************************************** connectControl: host = %@", hostTextField.text);
    
    (!player) ? [self doConnect] : [self doDisconnect];
    
}

-(IBAction)playControl:(id)sender; {
    
    NSLog(@"********************************************* playControl: stream = %@", streamTextField.text);
    
    (player.state != STREAM_PLAYING) ? [player start] : [player pause];
    
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark IMediaStreamEvent Methods

-(void)stateChanged:(id)sender state:(MediaStreamState)state description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: %d = %@", (int)state, description);
    
    switch (state) {
            
        case CONN_DISCONNECTED: {
            
            [self setDisconnect];
             
            break;
        }
            
        case STREAM_CREATED: {
            
            [player start];
            
            hostTextField.hidden = YES;
            streamTextField.hidden = YES;
            previewView.hidden = NO;
            
            btnPlay.enabled = YES;
            
            break;
            
        }
            
        case STREAM_PAUSED: {
            
            btnPlay.title = @"Start";
            
            break;
        }
            
        case STREAM_PLAYING: {
            
            if ([description isEqualToString:@"NetStream.Play.StreamNotFound"]) {
                
                [player stop];
                [self showAlert:[NSString stringWithString:description]];
                
                break;
            }
            
            btnPlay.title = @"Pause";
            
            break;
        }
            
        default:
            break;
    }
}

-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> connectFailedEvent: %d = %@\n", code, description);
    
    [self setDisconnect];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

-(void)metadataReceived:(id)sender metadata:(NSDictionary *)metadata {
    NSLog(@" $$$$$$ <IMediaStreamEvent> dataReceived: METADATA = %@", metadata);
}

@end
