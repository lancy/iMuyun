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
@property (weak, nonatomic) IBOutlet UITextField *repeatTextField;
@property (weak, nonatomic) IBOutlet UITextField *languageTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerView;
@property (strong, nonatomic) IBOutlet UIView *languageInputAccessoryView;


- (IBAction)tapSignUpButton:(id)sender;
- (IBAction)tapBackButton:(id)sender;

@end
