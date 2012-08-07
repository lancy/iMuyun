//
//  IMYRegisterViewController.h
//  iMuyun
//
//  Created by Lancy on 7/8/12.
//
//

#import <UIKit/UIKit.h>
#import "IMYHttpClient.h"
#import "ASIHttpRequest.h"

@interface IMYRegisterViewController : UIViewController <ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)tapSignUpButton:(id)sender;
- (IBAction)tapBackButton:(id)sender;

@end
