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
@synthesize portraitImageView = _portraitImageView;
@synthesize callButton = _callButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
