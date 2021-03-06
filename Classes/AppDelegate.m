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
#import "FDTakeController.h" 


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

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
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
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    //[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:120];
    
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

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *urlAddress = kOAWidgetURL;
    urlAddress = [urlAddress stringByAppendingString:@"/main/fetchTest"];

    NSLog(@"Fetching with URL: %@", urlAddress);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
    NSURLConnection *connection;
    NSMutableData *buffer;

    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        buffer = [NSMutableData data];
        [connection start];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
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


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //NSLog(@"Application received remote notification: %@", userInfo);
    
    NSDictionary *values = [userInfo objectForKey:@"aps"];
    NSString *payload = [values objectForKey:@"payload"];
    NSString *payload_params = [values objectForKey:@"payload_params"];
    NSString *debug = [values objectForKey:@"debug"];
    NSLog(@"%@" , debug);
    
    //NSLog(@"%@", payload);
    //NSLog(@"%@", payload_params);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // debug
    /*
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    NSDate *beginOfDay = [calendar dateFromComponents:components];
    NSInteger numberOfSteps = 1234;

    NSLog(@"%@", now);
    NSString *json = @"{";
    
    [defaults setObject:json forKey:@"steps"];
    [defaults synchronize];
    
    // insert as empty setting
    for (int i = 0; i < 96; i++) {
        beginOfDay = [now dateByAddingTimeInterval:-900*i];
     
                //NSLog(@"%i %@ had steps %ld", i, beginOfDay, (long)numberOfSteps);
                NSString *dateString = [NSDateFormatter localizedStringFromDate:beginOfDay
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterShortStyle];
                // NSString *json = @"{";
                // should read and append from settings
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *json = [defaults stringForKey:@"steps"];
                
                json = [json stringByAppendingString:@"\""];
                json = [[json stringByAppendingString:dateString] stringByAppendingString:@"\":"];
                json = [json stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)numberOfSteps]];
                json = [json stringByAppendingString:@","];
                
                // should push json to setings
                [defaults setObject:json forKey:@"steps"];
                [defaults synchronize];
                
        
                
            }
    
    json = [defaults stringForKey:@"steps"];
      NSLog(@"%@", json);
    
    */
    // end debug

    if([payload isEqualToString:@"sync"]) {
        NSLog(@"Received push to sync");
   
        NSString *stepsVal = @"";
        NSString *stepsVals = @"";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([CMStepCounter isStepCountingAvailable]) {
            
            stepsVals = [defaults stringForKey:@"steps"];
            stepsVal = [stepsVals substringToIndex:[stepsVals length]-1];
            stepsVal = [stepsVal stringByAppendingString:@"}"];

        }
        else {
            // debug
            //stepsVals = [defaults stringForKey:@"steps"];
            //stepsVal = [stepsVals substringToIndex:[stepsVals length]-1];
            //stepsVal = [stepsVal stringByAppendingString:@"}"];
            stepsVal = @"{}";
            // end debug
        }
        
        stepsVal = [self URLEncodeStringFromString:stepsVal];
        
            NSString *urlAddress = kOAWidgetURL;
            NSString *deviceToken = [defaults stringForKey:@"devicetoken"];
            NSURLConnection *connection;
            NSMutableData *buffer;
            
            urlAddress = [urlAddress stringByAppendingString:@"/main/externalPush?device=ios"];
            
            if (deviceToken != nil) {
                urlAddress = [urlAddress stringByAppendingString:[@"&device_id=" stringByAppendingString: deviceToken]];
            }
         
            NSNumber *timestamp;
            timestamp = [NSNumber numberWithDouble: floor([[NSDate date] timeIntervalSince1970])];
            
            urlAddress = [urlAddress stringByAppendingString:[@"&timestamp=" stringByAppendingString:[NSString stringWithFormat:@"%d", [timestamp integerValue] ]]];
        
            urlAddress = [urlAddress stringByAppendingString:[@"&steps=" stringByAppendingString:stepsVal]];
            NSLog(@"Syncing with URL: %@", urlAddress);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
            
            connection = [NSURLConnection connectionWithRequest:request delegate:self];
            
            if (connection) {
                buffer = [NSMutableData data];
                [connection start];
            }
            else {
                NSLog(@"Could not open connection");
            }

        
    }
    else if(debug) {
        NSString *cmd = [values objectForKey:@"cmd"];
        if([cmd isEqualToString:@"setbaseurl"]) {
            NSString *baseurl = [values objectForKey:@"baseurl"];
            NSLog(@"New baseurl set to %@", baseurl);
            [defaults setObject:baseurl forKey:@"baseurl"];
            [defaults synchronize];

        }
    }
    else {
        
        [defaults setObject:payload forKey:@"payload"];
        [defaults setObject:payload_params forKey:@"payload_params"];
        [defaults synchronize];
    }
    
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
    
    
    // set a payload to reload the dataset
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"loadDataset" forKey:@"payload"];
    [defaults setObject:@"" forKey:@"payload_params"];
    [defaults synchronize];
    //NSLog(@"Returning from background");
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
    //NSLog(@"This was fired off");
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
