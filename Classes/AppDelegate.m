//
//  iStudentistAppDelegate.m
//  iStudentist
//
//  Created by macuser on 16.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "WidgetViewController.h"


@implementation UINavigationBar (UINavigationBarCategory)

- (void) drawRect:(CGRect) rect {
	UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar"];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), backgroundImage.CGImage);
}

@end


@implementation AppDelegate

@synthesize window;
@synthesize navController;
@synthesize splashViewController;
@synthesize widgetViewController;



// -------------------------------------------------------------------------------

- (void) showMainScreen {
	widgetViewController = [[WidgetViewController alloc] init];
	widgetViewController.view.alpha = 0.0;
	
	navController.viewControllers = [NSArray arrayWithObject:widgetViewController];
    [navController setNavigationBarHidden:YES animated:NO];
	[window addSubview:navController.view];
	
	[splashViewController release];
	splashViewController = nil;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	
    widgetViewController.view.alpha = 1.0;
	
	[UIView commitAnimations];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    [self.window addSubview:splashViewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    //NSLog(@"My token is: %@", devToken);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:devToken forKey:@"devicetoken"];
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

// -------------------------------------------------------------------------------

- (void) applicationWillResignActive:(UIApplication *) application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

// -------------------------------------------------------------------------------

- (void) applicationDidEnterBackground:(UIApplication *) application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

// -------------------------------------------------------------------------------

- (void) applicationWillEnterForeground:(UIApplication *) application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

// -------------------------------------------------------------------------------

- (void) applicationDidBecomeActive:(UIApplication *) application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

// -------------------------------------------------------------------------------

- (void) applicationWillTerminate:(UIApplication *) application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"This was fired off");
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning:(UIApplication *) application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

// -------------------------------------------------------------------------------

- (void) dealloc {
	[navController             release];
	[splashViewController      release];
    [widgetViewController      release];
    [window                    release];
	
    [super dealloc];
}

// -------------------------------------------------------------------------------

@end
