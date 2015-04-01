//
//  ActivityView.h
//  iAAddressBook
//
//  Created by denis kotenko on 25.11.10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kActivityViewMaxAlpha 0.70

@interface DKActivityView : UIView {

	CGFloat maxAlpha;                                                                                                                                                                 
	UILabel *titleLable;
	UILabel *messageLable;
	UIActivityIndicatorView *activityIndicator;
	
}

@property (readonly) CGFloat maxAlpha;

- (id) initWithTitle:(NSString *) theTitle andMessage:(NSString *) theMessage;

@end
