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

@interface IMYAppDelegate : UIResponder <ASIHTTPRequestDelegate ,UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL isInCall;

@end
