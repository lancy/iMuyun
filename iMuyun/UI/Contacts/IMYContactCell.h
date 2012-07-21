//
//  IMYContactCell.h
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMYContactCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* companyLabel;
@property (nonatomic, weak) IBOutlet UIImageView* portraitImageView;

- (IBAction)tapTheCallButton:(id)sender;

@end
