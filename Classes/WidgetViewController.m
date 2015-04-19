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

@synthesize delegate;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)dealloc
{
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

@end
