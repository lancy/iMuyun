//
//  IMYProfileViewController.h
//  iMuyun
//
//  Created by Lancy on 12/8/12.
//
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface IMYProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

- (IBAction)tapPortraitButton:(id)sender;
@end
