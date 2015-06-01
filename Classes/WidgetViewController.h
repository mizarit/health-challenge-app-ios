//
//  WidgetViewController.h
//  OnlineAfspraken
//
//  Created by mac on 06-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioToolbox/AudioServices.h"
#import "FDTakeController.h"


@interface WidgetViewController : DKViewController<UIWebViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    id delegate;
    
    NSTimer     *theTimer;

    IBOutlet UIWebView *webView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIWebView *webView;

@property (assign) NSInteger stepsToday;

@property FDTakeController *takeController;

@end
