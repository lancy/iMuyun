//
//  IMYLoginViewController.h
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYHttpClient.h"

@interface IMYLoginViewController : UIViewController<ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *moveView;

- (IBAction)tapTheLoginButton:(id)sender;
@end
