//
//  IMYContactCell.m
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYContactCell.h"

@implementation IMYContactCell
@synthesize nameLabel = _nameLabel;
@synthesize companyLabel = _companyLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize callButton = _callButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.avatarImageView.layer.masksToBounds= NO;
        //    self.avatarImageView.layer.cornerRadius= 5.0f;
        self.avatarImageView.layer.borderWidth = 2.0f;
        
        self.avatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.avatarImageView.layer.shadowOffset = CGSizeMake(3, 3);
        self.avatarImageView.layer.shadowOpacity = 0.5;
        self.avatarImageView.layer.shadowRadius = 2.0;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (IBAction)tapTheCallButton:(id)sender
//{
//    NSLog(@"tap the call button to call someone");
//    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:tableView]];
//}

@end
