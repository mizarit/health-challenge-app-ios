//
//  WidgetViewController.m
//  OnlineAfspraken
//
//  Created by mac on 06-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WidgetViewController.h"
#import "UIView+Toast.h"

@implementation WidgetViewController
{
    CMStepCounter *_stepCounter;
    NSInteger _stepsToday;
    NSInteger _stepsAtBeginOfLiveCounting;
    BOOL _isLiveCounting;
    NSOperationQueue *_stepQueue;
}

@synthesize delegate;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"Loading URL: %@", @" test" );
        _stepCounter = [[CMStepCounter alloc] init];
        self.stepsToday = -1;
        
        NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
        
        [noteCenter addObserver:self selector:@selector(timeChangedSignificantly:) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [noteCenter addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [noteCenter addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        _stepQueue = [[NSOperationQueue alloc] init];
        _stepQueue.maxConcurrentOperationCount = 1;
        
        [self _updateStepsTodayFromHistoryLive:YES];
        
         
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //self.title = NSLocalizedString(kCompanyName, kCompanyName);
    
    NSString *urlAddress = kOAWidgetURL;
    urlAddress = [urlAddress stringByAppendingString:@"?device=ios"];
    
    if([CMStepCounter isStepCountingAvailable]) {
        urlAddress = [urlAddress stringByAppendingString:@"&sensor=1"];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults stringForKey:@"devicetoken"];
    
    if(deviceToken != nil) {
        
        NSLog(@"My stored token is: %@", deviceToken);
        urlAddress = [urlAddress stringByAppendingString:[@"&ios_id=" stringByAppendingString: deviceToken]];
        NSLog(@"Loading URL: %@", urlAddress);
    }
    

    [webView setDelegate:self];
    
    webView.scrollView.bounces = NO;
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    // VIBRATE
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // SOUND AND VIBRATE
    //AudioServicesPlaySystemSound(1007);
    
    // JUST SOUND
    /*
     AVAudioSession* session = [AVAudioSession sharedInstance];
    BOOL success;
    NSError* error;
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:&error];
    if (!success)  {
        NSLog(@"AVAudioSession error setting category:%@",error);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else {
        SystemSoundID myAlertSound;
        NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
        AudioServicesPlaySystemSound(myAlertSound);
    }
    */

    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *setting = [defaults stringForKey:@"allowVibrate"];
    NSLog(@"setting:%@", setting);
    [defaults setObject:@"YES" forKey:@"allowVibrate"];
    [defaults synchronize];
    setting = [defaults stringForKey:@"allowVibrate"];
    NSLog(@"setting:%@", setting);
    */
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // setup a timer to check for payload drops
    float theInterval = 1.0;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval
                                                target:self selector:@selector(checkPayload:)
                                              userInfo:nil repeats:YES];
}

- (void) checkPayload:(NSTimer *) timer {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *payload_cache = [defaults stringForKey:@"payload"];
    NSString *payload_params_cache = [defaults stringForKey:@"payload_params"];
    if(![payload_cache isEqualToString:@""]) {
        NSString *callback = [[[payload_cache stringByAppendingString:@"("] stringByAppendingString:payload_params_cache] stringByAppendingString:@");"];
        NSLog(@"Payload with callback: %@", callback);
        
        NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:callback];
        
        [defaults setObject:@"" forKey:@"payload"];
        [defaults setObject:@"" forKey:@"payload_params"];
        [defaults synchronize];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray *requestArray = [requestString componentsSeparatedByString:@":##sendToApp##"];
    
    if ([requestArray count] > 1){
        NSString *requestPrefix = [[requestArray objectAtIndex:0] lowercaseString];
        NSString *requestMssg = ([requestArray count] > 0) ? [requestArray objectAtIndex:1] : @"";
        [self webviewMessageKey:requestPrefix value:requestMssg];
        return NO;
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked && [self shouldOpenLinksExternally]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}
- (void)webviewMessageKey:(NSString *)key value:(NSString *)val {
    if ([key isEqualToString:@"ios-log"]) {
        NSLog(@"__js__>> %@", val);
    }
    else if([key isEqualToString:@"beep"]) {
        AVAudioSession* session = [AVAudioSession sharedInstance];
        BOOL success;
        NSError* error;
        success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                                 error:&error];
        if (!success)  {
            NSLog(@"AVAudioSession error setting category:%@",error);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        else {
            SystemSoundID myAlertSound;
            NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
            AudioServicesPlaySystemSound(myAlertSound);
        }
    }
    else if([key isEqualToString:@"vibrate"]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else if([key isEqualToString:@"toast"]) {
        NSLog(@"Toast %@", val);
        [self.view makeToast:val];
    }
    else if([key isEqualToString:@"getsetting"]) {
        //NSLog(@"getSetting %@", val);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *setting = [defaults stringForKey:val];
        //NSLog(@"%@", setting);
        if(setting == nil) setting = @"NO";
        NSString *callback = [NSString stringWithFormat:@"returnValue('%@');", setting];
        
        //NSLog(@"%@", callback);
        
        [webView stringByEvaluatingJavaScriptFromString:callback];
    }
    else if([key isEqualToString:@"setsetting"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *setting = [defaults stringForKey:val];
        if([setting isEqualToString:@"YES"]) {
            setting = @"NO";
        }
        else {
            setting = @"YES";
        }
        NSLog(@"Set setting %@ to %@", val, setting);
        [defaults setObject:setting forKey:val];
        [defaults synchronize];
        if([setting isEqualToString:@"YES"]) {
            if([val isEqualToString:@"vibrate"]) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            } else if([val isEqualToString:@"sound"]) {
                AVAudioSession* session = [AVAudioSession sharedInstance];
                BOOL success;
                NSError* error;
                success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                                         error:&error];
                if (!success)  {
                    NSLog(@"AVAudioSession error setting category:%@",error);
                    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                else {
                    SystemSoundID myAlertSound;
                    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
                    AudioServicesPlaySystemSound(myAlertSound);
                }

            } else if([val isEqualToString:@"notifications"]) {
                NSString *hasSound = [defaults stringForKey:@"sound"];
                NSString *hasVibrate = [defaults stringForKey:@"vibrate"];
                if ([hasSound isEqualToString:@"YES"]) {
                    if([hasVibrate isEqualToString:@"YES"]) {
                        AudioServicesPlaySystemSound(1007);
                    }
                    else {
                        AVAudioSession* session = [AVAudioSession sharedInstance];
                        BOOL success;
                        NSError* error;
                        success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                                                 error:&error];
                        if (!success)  {
                            NSLog(@"AVAudioSession error setting category:%@",error);
                            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        }
                        else {
                            SystemSoundID myAlertSound;
                            NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
                            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
                            AudioServicesPlaySystemSound(myAlertSound);
                        }

                    }
                }
                else {
                    if([hasVibrate isEqualToString:@"YES"]) {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                }

            }
        }
    }
   }
- (BOOL)shouldOpenLinksExternally {
    return YES;
}

-(void)_updateStepsTodayFromHistoryLive:(BOOL)startLiveCounting
{
    if(![CMStepCounter isStepCountingAvailable]) {
        NSLog(@" Step counting is not available on this device");
        self.stepsToday = -1;
        return;
    }
    
    NSLog(@" Step counting is available on this device");
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    NSDate *beginOfDay = [calendar dateFromComponents:components];
    
    
 
    
    NSLog(@"%@", now);
    NSString *json = @"{";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:json forKey:@"steps"];
    [defaults synchronize];
    
    // insert as empty setting
    for (int i = 0; i < 96; i++) {
        beginOfDay = [now dateByAddingTimeInterval:-900*i];
        [_stepCounter stopStepCountingUpdates];
        [_stepCounter queryStepCountStartingFrom:beginOfDay to:now toQueue:_stepQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
            if (!error) {
                NSLog(@"%i %@ had steps %ld", i, beginOfDay, (long)numberOfSteps);
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

                //NSLog(@"%@", json);
                        
            }
        }];
        
        
    }
    
    beginOfDay = [calendar dateFromComponents:components];
    /*
    [_stepCounter queryStepCountStartingFrom:beginOfDay to:now toQueue:_stepQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            self.stepsToday = -1;
        }
        else {
            self.stepsToday = numberOfSteps;
            
            if(startLiveCounting) {
                [self _startLiveCounting];
            }
        }
    }];
     */
}

-(void)_startLiveCounting
{
    if(_isLiveCounting) {
        return;
    }
    
    _isLiveCounting = YES;
    _stepsAtBeginOfLiveCounting = self.stepsToday;
    [_stepCounter startStepCountingUpdatesToQueue:_stepQueue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        self.stepsToday = _stepsAtBeginOfLiveCounting + numberOfSteps;
        NSLog(@"%ld", (long)self.stepsToday);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *steps = [NSString stringWithFormat: @"%ld", (long)self.stepsToday];
        [defaults setObject:steps forKey:@"steps"];
        [defaults synchronize];
        
    }];
    
    NSLog(@"Started live counting");
}

-(void)_stopLiveCounting
{
    if(!_isLiveCounting)
    {
        return;
    }
    [_stepCounter stopStepCountingUpdates];
    _isLiveCounting = NO;
    
    NSLog(@"Stopped live counting");
}

-(void)timeChangedSignificantly:(NSNotification *)notification
{
    [self _stopLiveCounting];
    [self _updateStepsTodayFromHistoryLive:YES];
}

-(void)willEnterForeground:(NSNotification *)notification
{
    [self _updateStepsTodayFromHistoryLive:YES];
}

-(void)didEnterBackground:(NSNotification *)notification
{
    [self _stopLiveCounting];
}

@end
