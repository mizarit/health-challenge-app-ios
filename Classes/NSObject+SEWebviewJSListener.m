//
//  NSObject+SEWebviewJSListener.m
//  HealthChallenge
//
//  Created by Ricardo on 16-04-15.
//
//

#import "NSObject+SEWebviewJSListener.h"

@implementation NSObject (SEWebviewJSListener)


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
        // open links in safari
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}


- (void)webviewMessageKey:(NSString *)key value:(NSString *)val {}

- (BOOL)shouldOpenLinksExternally {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.alertName();"];
}

@end