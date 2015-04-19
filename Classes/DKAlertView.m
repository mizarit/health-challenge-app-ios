//
//  DKAlertView.m
//  iQuickChecks
//
//  Created by macuser on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKAlertView.h"


@implementation DKAlertView

@synthesize delegate;
@synthesize alertTypeImage;

// -------------------------------------------------------------------------------

- (void) dealloc {
	[alertBackgroundView   release];
	[alertBackgroundButton release];
	[alertMessageLabel     release];
	[alertImageView        release];
	[alertTypeImageView    release];
	
	[super dealloc];
}

// -------------------------------------------------------------------------------

- (id) initWithMessage:(NSString *) theMessage andAlertIcon:(UIImage *) icon {
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	
	UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	BOOL portraitOrientation = currentOrientation == (UIInterfaceOrientationPortrait |UIInterfaceOrientationPortraitUpsideDown);
	
	if (portraitOrientation) {
		self = [super initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height + 20)];
	} else {
		self = [super initWithFrame:CGRectMake(
			appFrame.origin.x, appFrame.origin.y, 
			appFrame.size.height, appFrame.size.width + 20
		)];
	}
	
	if (self) {
		alertBackgroundView = [[UIView alloc] initWithFrame:self.frame];
		alertBackgroundView.backgroundColor = [UIColor blackColor];
		alertBackgroundView.alpha = 0.7f;
		[self addSubview:alertBackgroundView];
	
		UIImage *originalImage = [UIImage imageNamed:@"bg_allert_01"];
		UIImage *stretchImage  = [originalImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
		
		alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 175)];
		alertImageView.center = CGPointMake(self.center.x, self.center.y + 20);
		[alertImageView setImage:stretchImage];
		[self addSubview:alertImageView];
		
		alertMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 133)];
		alertMessageLabel.center          = CGPointMake(self.center.x + 40, self.center.y + 10);
		alertMessageLabel.numberOfLines   = 7;
		alertMessageLabel.backgroundColor = [UIColor clearColor];
		alertMessageLabel.textColor       = [UIColor darkGrayColor];
		alertMessageLabel.text            = theMessage;
		alertMessageLabel.font            = [UIFont systemFontOfSize:15];
		[self addSubview:alertMessageLabel];
		
		alertTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 62)];
		alertTypeImageView.center = CGPointMake(55, self.center.y + 10);
		[alertTypeImageView setImage:icon];
		[self addSubview:alertTypeImageView];
		
		alertBackgroundButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[alertBackgroundButton addTarget:self action:@selector(close) 
			forControlEvents:UIControlEventTouchUpInside];
		alertBackgroundButton.frame           = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		alertBackgroundButton.backgroundColor = [UIColor clearColor];
		[self addSubview:alertBackgroundButton];
	}
	
	return self;
}

// -------------------------------------------------------------------------------

- (void) close {
	if (self.delegate == nil && 
		[self.delegate conformsToProtocol:@protocol(DKAlertViewDelegate)]) return;
	
	[self.delegate closeAlertView:YES];
}

// -------------------------------------------------------------------------------

@end
