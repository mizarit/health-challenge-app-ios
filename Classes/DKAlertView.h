//
//  DKAlertView.h
//  iQuickChecks
//
//  Created by macuser on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DKAlertViewDelegate <NSObject>

- (void) closeAlertView:(BOOL) animated;

@end


@interface DKAlertView : UIView {

	id<DKAlertViewDelegate> delegate;
	
	UIView      *alertBackgroundView;
	UIButton    *alertBackgroundButton;
	UILabel     *alertMessageLabel;
	UIImageView *alertImageView;
	UIImageView *alertTypeImageView;
	
}

@property (nonatomic, assign) id<DKAlertViewDelegate> delegate;
@property (nonatomic, retain) UIImage *alertTypeImage;

- (id) initWithMessage:(NSString *) theMessage andAlertIcon:(UIImage *) icon;

@end
