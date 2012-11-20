//
//  ViewController.m
//  RTMPStreamPlayer
//
//  Created by Vyacheslav Vdovichenko on 7/11/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"
#import "VideoPlayer.h"


@implementation ViewController

#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //hostTextField.text = @"rtmp://192.168.2.100:1935/weborb";
    
    //hostTextField.text = @"rtmp://192.168.1.101:1935/live";
    hostTextField.text = @"rtmp://10.0.1.33:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.101:1935/live";
    //hostTextField.text = @"rtmp://192.168.1.63:1935/live";
    //hostTextField.text = @"rtmp://demo.eudata.biz:1935/live";
    hostTextField.delegate = self;
    
    streamTextField.text = @"slavav";
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

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self 
                                       cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)doConnect {
    
    FramesPlayer *_player = [[FramesPlayer alloc] initWithView:previewView];
    _player.orientation = UIImageOrientationRight;
   
    player = [[MediaStreamPlayer alloc] init:hostTextField.text];
    player.delegate = self;
    player.player = _player;
    [player stream:streamTextField.text];    
    
    btnConnect.title = @"Disconnect"; 
}

-(void)doDisconnect {
    
    [player disconnect];
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
    
    NSLog(@"connectControl: host = %@", hostTextField.text);
    
    (!player) ? [self doConnect] : [self doDisconnect];
    
}

-(IBAction)playControl:(id)sender; {
    
    NSLog(@"playControl: stream = %@", streamTextField.text);
    
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
            
            [self doDisconnect];
            [self showAlert:[NSString stringWithString:description]];
            
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
    
    [self doDisconnect];
    
    [self showAlert:(code == -1) ?
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] :
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];
}

@end
