//
//  DKTextField.m
//  iStudentist
//
//  Created by macuser on 22.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKTextField.h"


@implementation DKTextField

// -------------------------------------------------------------------------------

- (CGRect) textRectForBounds:(CGRect) bounds {
	//return CGRectInset(bounds, 10, 10);
	CGRect b = [super textRectForBounds:bounds];
    b.origin.x += 12;
    return b;
	
}

// -------------------------------------------------------------------------------

- (CGRect) editingRectForBounds:(CGRect) bounds {
	//return CGRectInset(bounds, 10, 10);
	CGRect b = [super textRectForBounds:bounds];
    b.origin.x += 12;
    return b;
	
}

// -------------------------------------------------------------------------------

@end
