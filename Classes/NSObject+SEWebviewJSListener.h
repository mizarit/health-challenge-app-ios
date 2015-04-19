//
//  NSObject+SEWebviewJSListener.h
//  HealthChallenge
//
//  Created by Ricardo on 16-04-15.
//
//

@interface NSObject (SEWebviewJSListener)


- (void)webviewMessageKey:(NSString *)key value:(NSString *)val;
- (BOOL)shouldOpenLinksExternally;

@end