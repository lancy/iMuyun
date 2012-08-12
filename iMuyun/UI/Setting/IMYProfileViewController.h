//
//  IMYProfileViewController.h
//  iMuyun
//
//  Created by Lancy on 12/8/12.
//
//

#import <UIKit/UIKit.h>

@interface IMYProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

- (IBAction)tapPortraitButton:(id)sender;
@end
