//
//  SplashViewController.m
//  iStudentist
//
//  Created by macuser on 18.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "WidgetViewController.h"
#import "PDColoredProgressView.h"

@implementation SplashViewController

@synthesize progressImageView;
@synthesize progressBGImageView;

@synthesize delegate;
@synthesize webView;
// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Memory Managment Methods

- (void) dealloc {
	self.progressImageView   = nil;
	self.progressBGImageView = nil;
	
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Load Methods

- (void) viewDidLoad {
    [super viewDidLoad];

    NSString *urlAddress = kOAWidgetURL;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults stringForKey:@"devicetoken"];
    
    if (deviceToken != nil) {
        NSLog(@"My stored token is: %@", deviceToken);
        urlAddress = [urlAddress stringByAppendingString:[@"&ios_id=" stringByAppendingString: deviceToken]];
    }
    NSLog(@"Loading URL: %@", urlAddress);
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];

	completeXPosition = fabs(progressBGImageView.frame.origin.x - fabs(progressImageView.frame.origin.x));

	float theInterval = 1.0 / 50.0;
	theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval 
		target:self selector:@selector(updateProgressView:) 
		userInfo:nil repeats:YES];
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [super viewDidUnload];
	
	self.progressImageView   = nil;
	self.progressBGImageView = nil;
}


- (void) updateProgressView:(NSTimer *) timer {
	counter++;
	
	if (self.progressImageView.center.x >= self.progressBGImageView.center.x) {
		[theTimer invalidate];
		[self splashScreenWillClose];
		return;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
    CGFloat progress = 1.6f;
    self.progressImageView.center = CGPointMake(
                                                self.progressImageView.center.x + progress, self.progressImageView.center.y
                                                );
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Splash Screen Methods

- (void) splashScreenWillClose {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(splashScreenDidClose)];
	
		self.view.alpha = 0.0;
	
	[UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) splashScreenDidClose {
	[self.view removeFromSuperview];
	[appDelegate showMainScreen];
}

// -------------------------------------------------------------------------------

@end
