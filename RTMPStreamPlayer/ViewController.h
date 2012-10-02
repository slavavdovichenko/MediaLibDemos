//
//  ViewController.h
//  RTMPStreamPlayer
//
//  Created by Vyacheslav Vdovichenko on 7/11/12.
//  Copyright (c) 2012 The Midnight Coders, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaStreamPlayer.h"

@interface ViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, IMediaStreamEvent> {
    
    MediaStreamPlayer       *player;
    
	IBOutlet UITextField	*hostTextField;
	IBOutlet UITextField	*streamTextField;
    IBOutlet UIImageView    *previewView;
    IBOutlet UIBarButtonItem *btnConnect;
    IBOutlet UIBarButtonItem *btnPlay;
    
}

-(IBAction)connectControl:(id)sender;
-(IBAction)playControl:(id)sender;

@end
