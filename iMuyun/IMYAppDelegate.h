//
//  IMYAppDelegate.h
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpRequest.h"
#import "IMYVideoCallViewController.h"
#import "JMTabview.h"

@interface IMYAppDelegate : UIResponder <ASIHTTPRequestDelegate ,UIApplicationDelegate, JMTabViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property BOOL isInCall;

@end
