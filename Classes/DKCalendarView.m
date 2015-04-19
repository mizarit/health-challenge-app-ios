//
//  DKCalendarView.m
//  iStudentist
//
//  Created by macuser on 18.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DKCalendarView.h"


@implementation DKCalendarView

// -------------------------------------------------------------------

- (void) dealloc {
	[topBarImageView   release];
	[daysImageView     release];
	[prevMonthButton   release];
	[nextMonthButton   release];
	[currentMonthLabel release];
	
	[super dealloc];
}

// -------------------------------------------------------------------

- (id) initWithOrigin:(CGPoint) origin {
	self = [super initWithFrame:CGRectMake(origin.x, origin.y, 175, 183)];
	if (self) {
		topBarImageView = [[UIImageView alloc] 
			initWithFrame:CGRectMake(0, 0, self.frame.size.width, 38)];
		[topBarImageView setImage:[UIImage imageNamed:@"calendar_top"]];
		[self addSubview:topBarImageView];
		
		daysImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 175, 21)];
		[daysImageView setImage:[UIImage imageNamed:@"days"]];
		[self addSubview:daysImageView];
		
		prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
		[prevMonthButton setBackgroundImage:[UIImage imageNamed:@"button_calendar_activ_left"] 
			forState:UIControlStateNormal];
		[prevMonthButton setBackgroundImage:[UIImage imageNamed:@"button_calendar_activ_left_tap"] 
			forState:UIControlStateHighlighted];
		[prevMonthButton addTarget:self action:@selector(prevMonthButtonHandler:)
			forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:prevMonthButton];
		
		nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(137, 0, 38, 38)];
		[nextMonthButton setBackgroundImage:[UIImage imageNamed:@"button_calendar_activ_right"] 
			forState:UIControlStateNormal];
		[nextMonthButton setBackgroundImage:[UIImage imageNamed:@"button_calendar_activ_right_tap"] 
			forState:UIControlStateHighlighted];
		[nextMonthButton addTarget:self action:@selector(nextMonthButtonHandler:)
			forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:nextMonthButton];
		
		currentMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 99, 38)];
		currentMonthLabel.font            = [UIFont boldSystemFontOfSize:15];
		currentMonthLabel.backgroundColor = [UIColor clearColor];
		//currentMonthLabel.textAlignment   = UITextAlignmentCenter;
		currentMonthLabel.textColor       = [UIColor whiteColor];
		currentMonthLabel.text            = @"February 2011";
		[self addSubview:currentMonthLabel];
	}
	return self;
}

// -------------------------------------------------------------------

- (void) prevMonthButtonHandler:(id) sender {
	
}

// -------------------------------------------------------------------

- (void) nextMonthButtonHandler:(id) sender {

}

// -------------------------------------------------------------------

@end
