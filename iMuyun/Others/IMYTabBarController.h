//
//  IMYTabBarController.h
//  iMuyun
//
//  Created by Lancy on 19/8/12.
//
//

#import <UIKit/UIKit.h>
#import "JMTabview.h"

@interface IMYTabBarController : UITabBarController <JMTabViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) JMTabView *jmTabview;

@end
