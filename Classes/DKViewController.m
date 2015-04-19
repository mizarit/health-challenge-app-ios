//
//  BaseViewController.m
//  iAAddressBook
//
//  Created by denis kotenko on 24.11.10.
//  Copyright 2010 home. All rights reserved.
//

#import "DKViewController.h"
#import "DKActivityView.h"
#import "DKAlertView.h"


@implementation DKViewController

@synthesize appDelegate;

// -------------------------------------------------------------------------------

- (void) viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	/*
	UILabel *label = [[UILabel alloc] 
		initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

	label.backgroundColor = [UIColor clearColor];
	label.font            = [UIFont boldSystemFontOfSize:23.0];
	//label.shadowColor     = [UIColor colorWithWhite:0.0 alpha:0.5];
	//label.textAlignment   = UITextAlignmentCenter;
	label.textColor       = [UIColor whiteColor];
	label.text            = self.title;	
	[label sizeToFit];
	self.navigationItem.titleView = label;
	[label release];
     */
}

// -------------------------------------------------------------------------------

- (void) setTabBarHidden:(BOOL) hidden animated:(BOOL) animated {
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		for (UIView *view in self.tabBarController.view.subviews) {
			if([view isKindOfClass:[UITabBar class]]) {
				if (hidden) {
					[view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
				} else {
					[view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
				}
			} else {
				if (hidden) {
					[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
				} else {
					//[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
				}
			}
		}
		
		[UIView commitAnimations];
	}
}

// -------------------------------------------------------------------------------

- (void) showErrorAlertWithMessage:(NSString *) msg { 
	[self alertViewDidClose];
	alertView = [[DKAlertView alloc] initWithMessage:msg andAlertIcon:[UIImage imageNamed:@"allert_icon"]];
	alertView.delegate = self;
	alertView.alpha    = 0.0f;
	[appDelegate.window addSubview:alertView];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
		alertView.alpha = 1.0f;
    [UIView commitAnimations];
} 

// -------------------------------------------------------------------------------

- (void) showActivityViewWithTitle:(NSString *) title andMessage:(NSString *) msg {
	activityView = [[DKActivityView alloc] initWithTitle:title andMessage:msg];
	activityView.alpha = 0.0f;
	[appDelegate.window addSubview:activityView];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
		activityView.alpha = activityView.maxAlpha;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) showAlertViewWithMessage:(NSString *) msg {
	//[self alertViewDidClose];
	
	alertView = [[DKAlertView alloc] initWithMessage:msg andAlertIcon:[UIImage imageNamed:@"allert_icon_ok"]];
	alertView.delegate = self;
	alertView.alpha    = 0.0f;
	[appDelegate.window addSubview:alertView];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
		alertView.alpha = 1.0f;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) showPopUpWithData:(NSData *) data {
	popUp = [[DKPopUp alloc] initWithData:data];
	popUp.delegate = self;
	popUp.alpha    = 0.0f;
	[appDelegate.window addSubview:popUp];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
		popUp.alpha = 1.0f;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) closeActivityView:(BOOL) animated {
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(activityViewDidClose)];
			activityView.alpha = 0.0f;
		[UIView commitAnimations];
	} else {
		[self activityViewDidClose];
	}
}

// -------------------------------------------------------------------------------

- (void) closeAlertView:(BOOL) animated {
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(activityViewDidClose)];
			alertView.alpha = 0.0f;
		[UIView commitAnimations];
	} else {
		[self alertViewDidClose];
	}
}

// -------------------------------------------------------------------------------

- (void) closePopUp:(BOOL) animated {
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(popUpDidClose)];
			popUp.alpha = 0.0f;
		[UIView commitAnimations];
	} else {
		[self popUpDidClose];
	}
}

// -------------------------------------------------------------------------------

- (void) activityViewDidClose {
	if (activityView != nil) {
		[activityView removeFromSuperview];
		[activityView release];
		activityView = nil;
	}
}

// -------------------------------------------------------------------------------

- (void) alertViewDidClose {
	if (alertView != nil) {
		[alertView removeFromSuperview];
		[alertView release];
		alertView = nil;
	}
}

// -------------------------------------------------------------------------------

- (void) popUpDidClose {
	if (popUp != nil) {
		[popUp removeFromSuperview];
		[popUp release];
		popUp = nil;
	}
}

// -------------------------------------------------------------------------------

- (void) dealloc {
	[activityView release];
	[alertView    release];
	
    [super dealloc];
}

// -------------------------------------------------------------------------------


@end
