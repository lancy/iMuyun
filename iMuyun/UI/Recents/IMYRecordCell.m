//
//  IMYRecordCell.m
//  iMuyun
//
//  Created by Lancy on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYRecordCell.h"

@implementation IMYRecordCell

@synthesize typeImageView = _typeImageView;
@synthesize nameLabel = _nameLabel;
@synthesize infoLabel = _infoLabel;

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

@end
