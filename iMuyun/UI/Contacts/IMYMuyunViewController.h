//
//  IMYMuyunViewController.h
//  iMuyun
//
//  Created by Lancy on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMYMuyunViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerView;
@property (strong, nonatomic) IBOutlet UIView *languageInputAccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *myLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *targetLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *videoCallButton;

- (IBAction)tapLanguageDoneButton:(id)sender;
- (IBAction)tapLanguageButton:(id)sender;

- (IBAction)tapVideoCallButton:(id)sender;
@end
