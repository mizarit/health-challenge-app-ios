//
//  DKPopUp.h
//  iStudentist
//
//  Created by macuser on 01.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DKPopUpDelegate <NSObject>

- (void) closePopUp:(BOOL) animated;

@end


@interface DKPopUp : UIView <UIWebViewDelegate> {

	id<DKPopUpDelegate> delegate;
	
	UIWebView   *webView;
	UIButton    *closeButton;
	UIView      *popUpBackgroundView;
	UIImageView *popUpImageView;
	
}

@property (nonatomic, assign) id<DKPopUpDelegate> delegate;

- (id) initWithData:(NSData *) data;

@end
