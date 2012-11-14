//
//  ViewController.h
//  RTMPStreamComeback
//
//  Created by Vyacheslav Vdovichenko on 11/13/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadcastStreamClient.h"
#import "MediaStreamPlayer.h"

@interface ViewController : UIViewController <IMediaStreamEvent> {
    
    BroadcastStreamClient    *upstream;
    MediaStreamPlayer        *player;
    
    UIActivityIndicatorView  *netActivity;
    
    IBOutlet UIImageView     *streamView;
    IBOutlet UIBarButtonItem *btnConnect;
    IBOutlet UIBarButtonItem *btnToggle;
    IBOutlet UIBarButtonItem *btnPublish;
    
}

-(IBAction)connectControl:(id)sender;
-(IBAction)publishControl:(id)sender;
-(IBAction)camerasToggle:(id)sender;

@end
