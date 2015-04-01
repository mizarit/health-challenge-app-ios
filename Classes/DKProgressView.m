//
//  DKProgressView.m
//  iStudentist
//
//  Created by macuser on 24.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKProgressView.h"


@implementation DKProgressView

- (void) awakeFromNib {
	[self setBackgroundColor:[UIColor clearColor]];
}

- (void) drawRect:(CGRect) rect {
	const int numParts = 10;
	UIImage *pb_left  = [UIImage imageNamed:@"pb_left.png"];  // "["
	UIImage *pb_right = [UIImage imageNamed:@"pb_right.png"]; // "]"
	UIImage *pb_on    = [UIImage imageNamed:@"pb_on.png"];    // "X"
	UIImage *pb_off   = [UIImage imageNamed:@"pb_off.png"];   // " "
	
	CGPoint p = {0,0};
	[pb_left drawAtPoint:p];
	
	p.x = pb_left.size.width;
	int q = (int) (self.progress * numParts);
	
	for (int i = 0; i < numParts; i++) {
		if (i == q)  // partial on/off section. works with semi-transparent images too
		{
			float w = truncf(pb_on.size.width * fmodf(self.progress * numParts, 1.0f));
			[pb_on drawInRect:CGRectMake(p.x, p.y, w, pb_on.size.height)];
			[pb_off drawInRect:CGRectMake(p.x + w, p.y, pb_on.size.width - w, pb_on.size.height)];
		}
		else if (i < q)
		{
			[pb_on drawAtPoint:p];
		}
		else // (i > q)
		{
			[pb_off drawAtPoint:p];
		}
		p.x += pb_on.size.width;
	}
	[pb_right drawAtPoint:p];
}

@end
