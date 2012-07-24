//
//  IMYContactsViewController.h
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "IMYHttpClient.h"

@interface IMYContactsViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, ASIHTTPRequestDelegate,ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactsTypeSegment;

- (IBAction)changeContactTypeSegmentValue:(id)sender;
- (IBAction)tapInvitedButton:(id)sender;

@end
