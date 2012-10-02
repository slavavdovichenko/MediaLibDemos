//
//  ViewController.m
//  RTMPStreamPublisher
//
//  Created by Vyacheslav Vdovichenko on 7/10/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //hostTextField.text = @"rtmp://192.168.2.100:1935/weborb";
    
    //hostTextField.text = @"rtmp://192.168.1.101:1935/live";
    //hostTextField.text = @"rtmp://10.0.1.33:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.101:1935/live";
    //hostTextField.text = @"rtmp://192.168.1.63:1935/live";
    hostTextField.text = @"rtmp://demo.eudata.biz:1935/live";
    hostTextField.delegate = self;

    streamTextField.text = @"slavav";
	streamTextField.delegate = self;
    
    [DebLog setIsActive:YES];
    
}

-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Private Methods 

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self 
                                       cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)doConnect {
    
    upstream = [[BroadcastStreamClient alloc] init:hostTextField.text resolution:RESOLUTION_LOW];
    upstream.delegate = self;
    [upstream setPreviewLayer:previewView orientation:AVCaptureVideoOrientationPortrait];
    [upstream stream:streamTextField.text publishType:PUBLISH_LIVE];  
    
    btnConnect.title = @"Disconnect"; 
}

-(void)doDisconnect {
    
    [upstream disconnect];
    upstream = nil;
    
    btnConnect.title = @"Connect";
    btnToggle.enabled = NO;
    btnPublish.title = @"Start";
    btnPublish.enabled = NO;
    
    hostTextField.hidden = NO;
    streamTextField.hidden = NO;
    
    previewView.hidden = YES;

}

#pragma mark -
#pragma mark Public Methods 

// ACTIONS

-(IBAction)connectControl:(id)sender {
    
    NSLog(@"connectControl: host = %@", hostTextField.text);
    
    (!upstream) ? [self doConnect] : [self doDisconnect];
}

-(IBAction)publishControl:(id)sender {
   
    NSLog(@"publishControl: stream = %@", streamTextField.text);
    
    (upstream.state != STREAM_PLAYING) ? [upstream start] : [upstream pause];
}

-(IBAction)camerasToggle:(id)sender {
    
    NSLog(@"camerasToggle:");
    
    if (upstream.state == STREAM_PLAYING)
        [upstream switchCameras];
 
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods 

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark IMediaStreamEvent Methods 

-(void)stateChanged:(MediaStreamState)state description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: %d = %@", (int)state, description);
    
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
            
            hostTextField.hidden = YES;
            streamTextField.hidden = YES;
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
            
            btnPublish.title = @"Pause";
            btnToggle.enabled = YES;
            
            break;
        }
            
        default:
            break;
    }
}

-(void)connectFailed:(int)code description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> connectFailedEvent: %d = %@\n", code, description);
    
    [self doDisconnect];
    
    [self showAlert:(code == -1) ? 
     [NSString stringWithFormat:@"Unable to connect to the server. Make sure the hostname/IP address and port number are valid\n"] : 
     [NSString stringWithFormat:@"connectFailedEvent: %@ \n", description]];    
}


@end
