//
//  MakeAppointmentViewController.m
//  iStudentist
//
//  Created by macuser on 21.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MakeAppointmentViewController.h"
#import "SelectBirthdayViewController.h"


@interface MakeAppointmentViewController (PrivateMethods)

- (NSInteger) pixelsToMove;
- (void) moveViewUpOrDownByPixels:(int) pixels;

@end


@implementation MakeAppointmentViewController

@synthesize appointment;
@synthesize scrollView;
@synthesize emailTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize addressTextField;
@synthesize postCode1TextField;
@synthesize postCode2TextField;	
@synthesize cityTextField;
@synthesize mobileNumberTextField;
@synthesize maleButton;
@synthesize femaleButton;
@synthesize selectBirthdayButton;

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Memory Managment Methods

- (void) dealloc {
	self.scrollView            = nil;
	self.emailTextField        = nil;
	self.firstNameTextField    = nil;
	self.lastNameTextField     = nil;
	self.addressTextField      = nil;
	self.postCode1TextField    = nil;
	self.postCode2TextField    = nil;	
	self.cityTextField         = nil;
	self.mobileNumberTextField = nil;
	self.maleButton            = nil;
	self.femaleButton          = nil;
	self.selectBirthdayButton  = nil;
	
	[appointment release];
	[birthdate   release];
	
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Load Methods

- (void) viewDidLoad {
	self.title = NSLocalizedString(@"STUDENTIST", @"STUDENTIST Main screen title");
    [super viewDidLoad];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardDidShow:) 
		name:UIKeyboardDidShowNotification object:self.view.window];
	[nc addObserver:self selector:@selector(keyboardDidHide:) 
		name:UIKeyboardDidHideNotification object:nil];
	
	self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [super viewDidUnload];
	
    self.scrollView            = nil;
	self.emailTextField        = nil;
	self.firstNameTextField    = nil;
	self.lastNameTextField     = nil;
	self.addressTextField      = nil;
	self.postCode1TextField    = nil;
	self.postCode2TextField    = nil;	
	self.cityTextField         = nil;
	self.mobileNumberTextField = nil;
	self.maleButton            = nil;
	self.femaleButton          = nil;
	self.selectBirthdayButton  = nil;
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
	if (birthdate != nil) {
		self.selectBirthdayButton.titleLabel.text = birthdate;
	}
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(0, 0, 50, 30);
	backButton.tag = kBackButtonTag;
	[backButton setBackgroundImage:[UIImage imageNamed:@"back"] 
		forState:UIControlStateNormal];
	[backButton setBackgroundImage:[UIImage imageNamed:@"back_tap"] 
		forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(backButtonHandler:) 
		forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backItem;
	[backItem release];
	
	
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	nextButton.frame = CGRectMake(0, 0, 50, 30);
	nextButton.tag = kBackButtonTag;
	[nextButton setBackgroundImage:[UIImage imageNamed:@"verder"] 
		forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[UIImage imageNamed:@"verder_tap"] 
		forState:UIControlStateHighlighted];
	[nextButton addTarget:self action:@selector(nextButtonHandler:) 
		 forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
	self.navigationItem.rightBarButtonItem = nextItem;
	[nextItem release];
}

// -------------------------------------------------------------------------------

- (void) setCustomer {
	NSString *lastName  = self.lastNameTextField.text;
	NSString *firstName = self.firstNameTextField.text
	NSString *sex;
	if (self.maleButton.selected) {
		sex = [NSString stringWithString:@"M"];
	} else {
		sex = [NSString stringWithString:@"V"];
	}
	NSString *street   = self.addressTextField.text;
	NSString *postcode = [NSString stringWithFormat:@"%@ %@", 
		self.postCode1TextField.text, self.postCode2TextField.text];
	NSString *place    = self.cityTextField.text; 
	NSString *mobile   = self.mobileNumberTextField.text;
	NSString *email    = self.emailTextField.text;
	
	OARequest *request = [[OARequest alloc] init];
	[request setCompleteCallback:self selector:@selector(completeSetCustomer:)];
	[request setFailedCallback:self selector:@selector(failedSetCustomer:)];
	[request setCustomer:lastName firstName:firstName birthdate:self.birthdate 
		sex:sex street:street postcode:postcode place:place mobile:mobile email:email];
}

// -------------------------------------------------------------------------------

- (void) completeSetCustomer:(NSString *) customerId {
	[self bookAppointment:customerId];
}

// -------------------------------------------------------------------------------

- (void) failedSetCustomer:(NSError *) error {
	NSLog(@"failedSetCustomer");
}

// -------------------------------------------------------------------------------

- (void) bookAppointment:(NSString *) customerId {
	OARequest *request = [[OARequest alloc] init];
	[request setCompleteCallback:self selector:@selector(completeBookAppointment:)];
	[request setFailedCallback:self selector:@selector(failedBookAppointment:)];
	[request bookAppointmentWithId:appointment.appointmentId 
		customerId:[customerId intValue] appointmentTypeId:appointment.appointmentTypeId 
		agendaId:appointment.agendaId startDate:appointment.date startTime:appointment.fromTime];
}

// -------------------------------------------------------------------------------

- (void) completeBookAppointment:(NSString *) appointmentId {
	
}

// -------------------------------------------------------------------------------

- (void) failedBookAppointment:(NSError *) error {
	NSLog(@"failedBookAppointment");
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Action Methods

- (IBAction) backButtonHandler:(id) sender {
	[self.navigationController popViewControllerAnimated:YES];
}

// -------------------------------------------------------------------------------

- (IBAction) nextButtonHandler:(id) sender {
	[self setCustomer];
}

// -------------------------------------------------------------------------------

- (IBAction) maleButtonHandler:(id) sender {
	if (self.maleButton.selected == NO) {
		self.femaleButton.selected = NO;
		self.maleButton.selected   = YES;
	}
}

// -------------------------------------------------------------------------------

- (IBAction) femaleButtonHandler:(id) sender {
	if (self.femaleButton.selected == NO) {
		self.maleButton.selected   = NO;
		self.femaleButton.selected = YES;
	}
}

// -------------------------------------------------------------------------------

- (IBAction) datePickerValueChanged:(id) sender {
	UIDatePicker *datePicker = (UIDatePicker *) sender;
	NSDate *date = datePicker.date;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	birthdate = [[NSString stringWithString:[dateFormat stringFromDate:date]] retain]; 
	[dateFormat release];
}

// -------------------------------------------------------------------------------

- (IBAction) selectBirthdayButton:(id) sender {
	SelectBirthdayViewController *selectBirthdayViewController = 
		[[SelectBirthdayViewController alloc] init];
	selectBirthdayViewController.delegate = self;
	[self.navigationController pushViewController:selectBirthdayViewController animated:YES];
	[selectBirthdayViewController release];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *) theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

// -------------------------------------------------------------------------------

- (void) textFieldDidBeginEditing:(UITextField *) theTextField {
	[self moveViewUpOrDownByPixels:[self pixelsToMove]];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) keyboardDidShow:(NSNotification *) notif {
	[self moveViewUpOrDownByPixels:[self pixelsToMove]];
}

// -------------------------------------------------------------------------------

- (void) keyboardDidHide:(NSNotification *) notif {
    [self moveViewUpOrDownByPixels:self.view.frame.origin.y];
}

// -------------------------------------------------------------------------------

- (NSInteger) pixelsToMove {
	CGRect textFieldFrame;
	
	if ([self.emailTextField isFirstResponder]) {
		textFieldFrame = self.emailTextField.frame;
	} else if ([self.firstNameTextField isFirstResponder]) {
		textFieldFrame = self.firstNameTextField.frame;
	} else if ([self.lastNameTextField isFirstResponder]) {
		textFieldFrame = self.lastNameTextField.frame;
	} else if ([self.addressTextField isFirstResponder]) {
		textFieldFrame = self.addressTextField.frame;
	} else if ([self.postCode1TextField isFirstResponder]) {
		textFieldFrame = self.postCode1TextField.frame;
	} else if ([self.postCode2TextField isFirstResponder]) {
		textFieldFrame = self.postCode2TextField.frame;
	} else if ([self.cityTextField isFirstResponder]) {
		textFieldFrame = self.cityTextField.frame;
	} else if ([self.mobileNumberTextField isFirstResponder]) {
		textFieldFrame = self.mobileNumberTextField.frame;
	}
	
	CGRect rect = self.view.frame;
	
	NSInteger pixelsToMove = rect.origin.y + textFieldFrame.origin.y - 45;
	return pixelsToMove;
}

// -------------------------------------------------------------------------------

- (void) moveViewUpOrDownByPixels:(int) pixels {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	
		CGRect rect = self.view.frame;
		
		rect.origin.y -= pixels;
		rect.size.height += pixels;
		self.scrollView.frame = rect;
	
	[UIView commitAnimations];
}

// -------------------------------------------------------------------------------

@end
