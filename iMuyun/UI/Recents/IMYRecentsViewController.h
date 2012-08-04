//
//  IMYRecentsViewController.h
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface IMYRecentsViewController : UITableViewController<ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *recentsTypeSegment;
- (IBAction)changeRecentsTypeSegmentValue:(id)sender;

@end
