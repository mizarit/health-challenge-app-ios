//
//  DKPopUp.m
//  iStudentist
//
//  Created by macuser on 01.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKPopUp.h"


@implementation DKPopUp

@synthesize delegate;

// -------------------------------------------------------------------------------

- (void) dealloc {
	[popUpBackgroundView release];
	[popUpImageView      release];
	[webView             release];
	
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (id) initWithData:(NSData *) data {
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
		popUpBackgroundView = [[UIView alloc] initWithFrame:self.frame];
		popUpBackgroundView.backgroundColor = [UIColor blackColor];
		popUpBackgroundView.alpha = 0.7f;
		[self addSubview:popUpBackgroundView];
		
		popUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 394)];
		popUpImageView.center = CGPointMake(160, 260);
		[popUpImageView setImage:[UIImage imageNamed:@"makeAppointmentPopup"]];
		[self addSubview:popUpImageView];
		
		closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		closeButton.frame  = CGRectMake(0, 0, 24, 25);
		closeButton.center = CGPointMake(
			popUpImageView.frame.origin.x + 10, popUpImageView.frame.origin.y + 5
		);
		[closeButton setBackgroundImage:[UIImage imageNamed:@"closePopup"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeButton];
		
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 280, 360)];
		webView.center          = popUpImageView.center;
		webView.backgroundColor = [UIColor clearColor];
		webView.delegate        = self;
		webView.opaque          = NO;
		((UIScrollView *) [webView.subviews objectAtIndex:0]).bounces = NO;
		[webView loadData:data MIMEType:@"text/html" 
			textEncodingName:@"iso-8859-1" baseURL:nil];
		[self addSubview:webView];
	}
	
	return self;
}

// -------------------------------------------------------------------------------

- (void) close {
	if (self.delegate == nil && 
		[self.delegate conformsToProtocol:@protocol(DKPopUpDelegate)]) return;
	
	[self.delegate closePopUp:YES];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (BOOL) webView:(UIWebView *) theWebView 
	shouldStartLoadWithRequest:(NSURLRequest *) request 
	navigationType:(UIWebViewNavigationType) navigationType {
	
	if ([[[request URL] absoluteString] isEqualToString:@"about:blank"]) {
		return YES;
	}
	
	[[UIApplication sharedApplication] openURL:[request URL]];
	
	return NO;
}

// -------------------------------------------------------------------------------

@end
