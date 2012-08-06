//
//  IMYAppDelegate.m
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYAppDelegate.h"
#import "IMYLoginViewController.h"
#import "IMYContactsViewController.h"
#import "IMYRecentsViewController.h"
#import "IMYSettingViewController.h"
#import "SFHFKeychainUtils.h"

@implementation IMYAppDelegate

@synthesize window = _window;

- (void)customizeAppearance
{
    // Create resizable images
//    UIImage *green1 = [UIImage imageNamed:@"green1"];
//    UIImage *green2 = [UIImage imageNamed:@"green2"];
//    UIImage *red1 = [UIImage imageNamed:@"red1"];
//    UIImage *blue1 = [UIImage imageNamed:@"blue1"];
    UIImage *background = [UIImage imageNamed:@"background"];
//    UIImage *gradientImage32 = [[UIImage imageNamed:@"surf_gradient_textured_32"] 
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    // Set the background image for *all* UINavigationBars
//    [[UINavigationBar appearance] setBackgroundImage:green1
//                                       forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:green1 
//                                       forBarMetrics:UIBarMetricsLandscapePhone];
//    [[UISearchBar appearance] setBackgroundImage:green2];
//    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithPatternImage:green1]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UISearchBar appearance] setBarStyle:UIBarStyleBlackTranslucent];

    [[UITableView appearanceWhenContainedIn:[IMYContactsViewController class], nil] setBackgroundView:[[UIImageView alloc] initWithImage:background]];
    [[UITableView appearanceWhenContainedIn:[IMYRecentsViewController class], nil] setBackgroundView:[[UIImageView alloc] initWithImage:background]];
    [[UITableViewCell appearanceWhenContainedIn:[IMYSettingViewController class], nil] setBackgroundView:[[UIImageView alloc] initWithImage:background]];

    
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    
    
    
    // Customize the title text for *all* UINavigationBars
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], 
//      UITextAttributeTextColor, 
//      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], 
//      UITextAttributeTextShadowColor, 
//      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], 
//      UITextAttributeTextShadowOffset, 
//      [UIFont fontWithName:@"Arial-Bold" size:0.0], 
//      UITextAttributeFont, 
//      nil]];
    
}

//- (void)autoLogin
//{
//    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
//    if (username) {
//        NSError *error;
//        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"iMuyun" error:&error];
//        [[IMYHttpClient shareClient] requestLoginWithUsername:username password:password delegate:self];
//    } else {
//        IMYLoginViewController *loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
//        [[self getCurrentViewController] presentModalViewController:loginVC animated:YES];
//    }
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSError *error;
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
//    NSLog(@"%@", result);
//    if ([[result valueForKey:@"requestType"] isEqualToString:@"login"]) {
//        if ([[result valueForKey:@"message"] isEqualToString:@"success"]) {
//            NSLog(@"auto login success");
//        } else {
//            IMYLoginViewController *loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
//            [[self getCurrentViewController] presentModalViewController:loginVC animated:YES];
//        }
//    }
//}


- (UIViewController *)getCurrentViewController
{
//    UITabBarController *tabBarVC = (UITabBarController *)[[self.window rootViewController] presentedViewController];
    UITabBarController *tabBarVC = self.tabBarController;
    UINavigationController *currentNav = (UINavigationController *)[tabBarVC selectedViewController];
    UIViewController *currentVC = [currentNav visibleViewController];
    return currentVC;
}

- (void)handleRemoteNotificaton:(NSDictionary *)userInfo
{
    
    if ([[userInfo valueForKey:@"callType"] isEqualToString:@"videoCall"] && ![self isInCall] ) {
        NSLog(@"Recieve video call");
        IMYVideoCallViewController *videoCallVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"videoCallViewController"];
        [videoCallVC setVideoCallState:IMYVideoCallStateCallIn];
        [videoCallVC setTargetContact:[userInfo valueForKey:@"callContact"]];
        
        
        [[self getCurrentViewController] presentModalViewController:videoCallVC animated:YES];
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"iMuyun did finish launching. launch Options = %@", launchOptions);

    
    [self setIsInCall:NO];
    
    [self customizeAppearance];
    
    
    if ([launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] != nil) {
        [self performSelector:@selector(handleRemoteNotificaton:) withObject:[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] afterDelay:1];
    }
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [UIApplication sharedApplication] setKeepAliveTimeout:<#(NSTimeInterval)#> handler:<#^(void)keepAliveHandler#>
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:@"myToken"];
    
	NSLog(@"Success to get push token, my token is: %@", newToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Did receive remote notification, userInfo = %@", userInfo);
    [self performSelector:@selector(handleRemoteNotificaton:) withObject:userInfo afterDelay:1];

}





@end
