//
//  ActivityView.m
//  iAAddressBook
//
//  Created by denis kotenko on 25.11.10.
//  Copyright 2010 home. All rights reserved.
//

#import "DKActivityView.h"


@implementation DKActivityView

@synthesize maxAlpha;

// -------------------------------------------------------------------------------

- (void) dealloc {
	[titleLable        release];
	[messageLable      release];
	[activityIndicator release];
	
	[super dealloc];
}

// -------------------------------------------------------------------------------

- (id) initWithTitle:(NSString *) theTitle andMessage:(NSString *) theMessage {
	self = [super init];
	if (!self) return nil;
	
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	
	UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	BOOL portraitOrientation = currentOrientation == (UIInterfaceOrientationPortrait |UIInterfaceOrientationPortraitUpsideDown);
	
	if (portraitOrientation) {
		[super initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height + 20)];
	} else {
		[super initWithFrame:CGRectMake(
			appFrame.origin.x, appFrame.origin.y, 
			appFrame.size.height, appFrame.size.width + 20
		)];
	}
	
	maxAlpha = kActivityViewMaxAlpha;
	
	self.backgroundColor = [UIColor blackColor];
	self.alpha = maxAlpha;
	
	titleLable = [[UILabel alloc] 
		initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, 42)]; 
	titleLable.center          = CGPointMake(self.center.x, self.center.y - 20);
	titleLable.numberOfLines   = 2;
	titleLable.backgroundColor = [UIColor clearColor];
	titleLable.shadowColor     = [UIColor blackColor];
	titleLable.shadowOffset    = CGSizeMake(-1, -1);
	titleLable.font            = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
	//titleLable.textAlignment   = UITextAlignmentCenter;
	titleLable.textColor       = [UIColor whiteColor];
	titleLable.text            = theTitle;
	[self addSubview:titleLable];
	
	messageLable = [[UILabel alloc]
		initWithFrame:CGRectMake(0, 0, self.frame.size.width, 21)];
	messageLable.center          = CGPointMake(self.center.x, self.center.y + 5);
	messageLable.backgroundColor = [UIColor clearColor];
	messageLable.shadowColor     = [UIColor blackColor];
	messageLable.shadowOffset    = CGSizeMake(-1, -1);
	//messageLable.textAlignment   = UITextAlignmentCenter;
	messageLable.textColor       = [UIColor whiteColor];
	messageLable.text            = theMessage;
	[self addSubview:messageLable];
	
	activityIndicator = [[UIActivityIndicatorView alloc] 
		initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center = CGPointMake(self.center.x, self.center.y + 40);
	[self addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
	return self;
}

// -------------------------------------------------------------------------------

@end
