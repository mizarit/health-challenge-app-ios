//
//  WidgetViewController.h
//  OnlineAfspraken
//
//  Created by mac on 06-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKViewController.h"


@interface WidgetViewController : DKViewController {
    id delegate;

    IBOutlet UIWebView *webView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIWebView *webView;

@end
