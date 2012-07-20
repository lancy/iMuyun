//
//  IMYViedoCallViewController.h
//  iMuyun
//
//  Created by lancy on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>



@interface IMYViedoCallViewController : UIViewController<OTSessionDelegate, OTPublisherDelegate, OTSubscriberDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)pressConnectButton:(id)sender;
- (IBAction)pressDropButton:(id)sender;


@end
