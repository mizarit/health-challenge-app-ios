
#import <UIKit/UIKit.h>


@class SplashViewController;
@class WidgetViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
    UIWindow               *window;
    UINavigationController *navController;
	SplashViewController   *splashViewController;
    WidgetViewController   *widgetViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow               *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet SplashViewController   *splashViewController;
@property (nonatomic, retain) IBOutlet WidgetViewController   *widgetViewController;
- (void) showMainScreen;

@end

