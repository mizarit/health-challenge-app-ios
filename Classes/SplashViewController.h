

#import <UIKit/UIKit.h>
#import "DKViewController.h"


@class PDColoredProgressView;

@interface SplashViewController : DKViewController {
	UIImageView *progressImageView;
	UIImageView *progressBGImageView;
	CGFloat     completeXPosition;

	NSTimer     *theTimer;
	int         counter;
    
    IBOutlet UIWebView *webView;
    id delegate;

}

@property (nonatomic, retain) IBOutlet UIImageView *progressImageView;
@property (nonatomic, retain) IBOutlet UIImageView *progressBGImageView;

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIWebView *webView;

- (void) splashScreenWillClose;
- (void) splashScreenDidClose;

@end
