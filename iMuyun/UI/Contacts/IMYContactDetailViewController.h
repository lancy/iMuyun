//
//  IMYContactDetailViewController.h
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMYContactDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary* contact;

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)tapFavoriteButton:(id)sender;

- (IBAction)tapMessageButton:(id)sender;
- (IBAction)tapAudioCallButton:(id)sender;
- (IBAction)tapVideoCallButton:(id)sender;

@end
