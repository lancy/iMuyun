//
//  IMYProfileViewController.h
//  iMuyun
//
//  Created by Lancy on 12/8/12.
//
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "IMYHttpClient.h"

@interface IMYProfileViewController : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASIHTTPRequestDelegate, UITextFieldDelegate, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *languageTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerView;
@property (strong, nonatomic) IBOutlet UIView *languageInputAccessoryView;

- (IBAction)textfieldDidEndOnExit:(id)sender;

@end
