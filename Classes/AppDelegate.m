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
#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
#endif
    
    [self.window addSubview:splashViewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application   didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

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

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //NSLog(@"Application received remote notification: %@", userInfo);
    
    NSDictionary *values = [userInfo objectForKey:@"aps"];
    NSString *payload = [values objectForKey:@"payload"];
    NSString *payload_params = [values objectForKey:@"payload_params"];
    //NSLog(@"%@", payload);
    //NSLog(@"%@", payload_params);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:payload forKey:@"payload"];
    [defaults setObject:payload_params forKey:@"payload_params"];
    [defaults synchronize];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)handleBackgroundNotification:(NSDictionary *)notification
{
    NSDictionary *aps = (NSDictionary *)[notification objectForKey:@"aps"];
    NSMutableString *alert = [NSMutableString stringWithString:@""];
    if ([aps objectForKey:@"alert"])
    {
        [alert appendString:(NSString *)[aps objectForKey:@"alert"]];
    }
    if ([notification objectForKey:@"payload"])
    {
        // do something with job id
        NSString *payload = [[notification objectForKey:@"payload"] stringValue];
        NSLog(@"Payload received: %@", payload);
    }
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
