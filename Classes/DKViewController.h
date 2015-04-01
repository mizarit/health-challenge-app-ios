//
//  BaseViewController.h
//  iAAddressBook
//
//  Created by denis kotenko on 24.11.10.
//  Copyright 2010 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DKPopUp.h"
#import "DKAlertView.h"
#import "DKActivityView.h"


@interface DKViewController : UIViewController 
	<DKAlertViewDelegate, DKPopUpDelegate> {
	
	DKPopUp        *popUp;
	DKAlertView    *alertView;
	DKActivityView *activityView;
	AppDelegate    *appDelegate;
	
}

@property (readonly) AppDelegate *appDelegate;

- (void) setTabBarHidden:(BOOL) hidden animated:(BOOL) animated;
- (void) showErrorAlertWithMessage:(NSString *) msg;
- (void) showActivityViewWithTitle:(NSString *) title andMessage:(NSString *) msg;
- (void) showAlertViewWithMessage:(NSString *) msg;
- (void) showPopUpWithData:(NSData *) data;
- (void) closeActivityView:(BOOL) animated;
- (void) closeAlertView:(BOOL) animated;
- (void) closePopUp:(BOOL) animated;
- (void) activityViewDidClose;
- (void) alertViewDidClose;
- (void) popUpDidClose;

@end
