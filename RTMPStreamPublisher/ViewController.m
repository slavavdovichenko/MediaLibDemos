//
//  ViewController.m
//  RTMPStreamPublisher
//
//  Created by Vyacheslav Vdovichenko on 7/10/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import "ViewController.h"
#import "DEBUG.h"
#import "MemoryTicker.h"
#import "BroadcastStreamClient.h"
#import "MediaStreamPlayer.h"


@interface ViewController () <IMediaStreamEvent> {
    MemoryTicker            *memoryTicker;
    RTMPClient              *socket;
    BroadcastStreamClient   *upstream;
}

-(void)sizeMemory:(NSNumber *)memory;
-(void)setDisconnect;
@end


@implementation ViewController

#pragma mark -
#pragma mark  View lifecycle

-(void)viewDidLoad {
    
    //[DebLog setIsActive:YES];
    
    [super viewDidLoad];
    
    memoryTicker = [[MemoryTicker alloc] initWithResponder:self andMethod:@selector(sizeMemory:)];
    memoryTicker.asNumber = YES;
    
    socket = nil;
    upstream = nil;
    
    //echoCancellationOn;
    
    //hostTextField.text = @"rtmp://10.0.1.33:1935/live";
    //hostTextField.text = @"rtmp://10.0.1.33:1935/videorecording";
    hostTextField.text = @"rtmp://192.168.2.105:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.63:1935/live";
    //hostTextField.text = @"rtmp://192.168.2.63:1935/videorecording";
    //hostTextField.text = @"rtmp://192.168.1.102:1935/live";
    hostTextField.delegate = self;

    streamTextField.text = @"outgoingaudio_c109";
    //streamTextField.text = @"myStream";
	streamTextField.delegate = self;
    
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
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Receive" message:message delegate:self
                                           cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    });
}

// ACTIONS

-(void)doConnect {
    
    //upstream = [[BroadcastStreamClient alloc] initOnlyAudio:hostTextField.text];
    //upstream = [[BroadcastStreamClient alloc] initOnlyVideo:hostTextField.text resolution:RESOLUTION_LOW];
    //upstream = [[BroadcastStreamClient alloc] init:hostTextField.text resolution:RESOLUTION_LOW];
    
    //
    if (!socket) {
        socket = [[RTMPClient alloc] init:hostTextField.text];
        if (!socket) {
            [self showAlert:@"Socket has not be created"];
            return;
        }
        
        [socket spawnSocketThread];
   }
    
    upstream = [[BroadcastStreamClient alloc] initWithClient:socket resolution:RESOLUTION_LOW];
    [upstream setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    //[upstream setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    //[upstream setVideoBitrate:512000];
    //
    
    upstream.delegate = self;
    
    [upstream stream:streamTextField.text publishType:PUBLISH_LIVE];
    //[upstream stream:streamTextField.text publishType:PUBLISH_RECORD];
    //[upstream stream:streamTextField.text publishType:PUBLISH_APPEND];
    
    
    //[upstream setAudioPickingSeconds:0.05f];
    //[upstream setAudioBitrate:64000];
    
    //
    
    btnConnect.title = @"Disconnect"; 
}

-(void)doDisconnect {
    [upstream disconnect];
}

-(void)setDisconnect {

    //
    [socket disconnect];
    socket = nil;
    //
    
    upstream = nil;
    
    btnConnect.title = @"Connect";
    btnToggle.enabled = NO;
    btnPublish.title = @"Start";
    btnPublish.enabled = NO;
    
    hostTextField.hidden = NO;
    streamTextField.hidden = NO;
    
    previewView.hidden = YES;
    
}

-(void)sendMetadata {
    
    NSString *camera = upstream.isUsingFrontFacingCamera ? @"FRONT" : @"BACK";
    NSDate *date = [NSDate date];
    NSDictionary *meta = [NSDictionary dictionaryWithObjectsAndKeys:camera, @"camera", [date description], @"date", nil];
    [upstream sendMetadata:meta event:@"changedCamera:"];
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
    
    if (upstream.state != STREAM_PLAYING)
        return;
    
    [upstream switchCameras];
    
    [self sendMetadata];
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
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> stateChangedEvent: %d = %@ [%@]", (int)state, description, [NSThread isMainThread]?@"M":@"T");
    
    switch (state) {
            
        case CONN_DISCONNECTED: {
            
            [self setDisconnect];
            
            break;
        }
            
        case CONN_CONNECTED: {
            
            if (![description isEqualToString:@"RTMP.Client.isConnected"])
                break;
            
            [upstream start];
            
            hostTextField.hidden = YES;
            streamTextField.hidden = YES;
            previewView.hidden = NO;
            
            btnPublish.enabled = YES;
            
            break;
           
        }
        
        case STREAM_CREATED: {
            [upstream setPreviewLayer:previewView];
            break;
        }
            
        case STREAM_PAUSED: {
            
            btnPublish.title = @"Start";
            btnToggle.enabled = NO;
            
            break;
        }
            
        case STREAM_PLAYING: {
            
            [self sendMetadata];
            
            btnPublish.title = @"Pause";
            btnToggle.enabled = YES;
            
            break;
        }
            
        default:
            break;
    }
}

-(void)connectFailed:(id)sender code:(int)code description:(NSString *)description {
    
    NSLog(@" $$$$$$ <IMediaStreamEvent> connectFailedEvent: %d = %@, [%@]", code, description, [NSThread isMainThread]?@"M":@"T");
    
    [self setDisconnect];
    
    [self showAlert:(code == -1) ? 
     @"Unable to connect to the server. Make sure the hostname/IP address and port number are valid" : 
     [NSString stringWithFormat:@"connectFailedEvent: %@", description]];
}

/*/// Send metadata for each video frame
-(void)pixelBufferShouldBePublished:(CVPixelBufferRef)pixelBuffer timestamp:(int)timestamp {
    
    //[upstream sendMetadata:@{@"videoTimestamp":[NSNumber numberWithInt:timestamp]} event:@"videoFrameOptions:"];
    
    //
    CVPixelBufferRef frameBuffer = pixelBuffer;
    
    // Get the base address of the pixel buffer.
    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(frameBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(frameBuffer);
    // Get the pixel buffer width and height.
    size_t width = CVPixelBufferGetWidth(frameBuffer);
    size_t height = CVPixelBufferGetHeight(frameBuffer);
    
    [upstream sendMetadata:@{@"videoTimestamp":[NSNumber numberWithInt:timestamp], @"bufferSize":[NSNumber numberWithInt:bufferSize], @"width":[NSNumber numberWithInt:width], @"height":[NSNumber numberWithInt:height]} event:@"videoFrameOptions:"];
    // 
}
/*/

@end
