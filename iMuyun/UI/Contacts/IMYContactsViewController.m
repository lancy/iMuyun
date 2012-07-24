//
//  IMYContactsViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYContactsViewController.h"
#import "IMYHttpClient.h"
#import "IMYContactCell.h"
#import "IMYContactDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "IMYMuyunViewController.h"

@interface IMYContactsViewController ()

// muyun contacts and favoirte contacts
@property (strong, nonatomic) NSArray *muyunContacts;
@property (strong, nonatomic) NSArray *favoriteContacts;


// selected contact full name phones and emails array;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSMutableArray *phonesArray;
@property (strong, nonatomic) NSMutableArray *emailsArray;
@end

@implementation IMYContactsViewController
@synthesize contactsTypeSegment = _contactsTypeSegment;
@synthesize fullName = _fullName;
@synthesize phonesArray = _phonesArray;
@synthesize emailsArray = _emailsArray;
@synthesize muyunContacts = _muyunContacts;
@synthesize favoriteContacts = _favoriteContacts;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setContactsTypeSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IMYHttpClient shareClient] requestContactsWithUsername:@"lancy" delegate:self];
    [[IMYHttpClient shareClient] requestFavoriteContactsWithUsername:@"lancy" delegate:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - contacts methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"%@", result);
    if ([[result valueForKey:@"requestType"] isEqualToString:@"contacts"] ) {
        if (![self.muyunContacts isEqualToArray:[result valueForKey:@"contacts"]]) {
            self.muyunContacts = [result valueForKey:@"contacts"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
        }
    } else if ([[result valueForKey:@"requestType"] isEqualToString:@"favoriteContacts"] ) {
        if (![self.favoriteContacts isEqualToArray:[result valueForKey:@"contacts"]]) {
            self.favoriteContacts = [result valueForKey:@"contacts"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (IBAction)changeContactTypeSegmentValue:(id)sender {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1; 
    } else {
        if ([self.contactsTypeSegment selectedSegmentIndex] == 0) {
            return [self.muyunContacts count];
        } else {
            return [self.favoriteContacts count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";
    IMYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        [cell.nameLabel setText:@"Muyun Interpreter"];
        [cell.companyLabel setText:@"Muyun Company"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://www.imuyun.com/themes/classic/img/favicon.ico"] placeholderImage:nil];
    } else {
        NSDictionary *contact;
        if ([self.contactsTypeSegment selectedSegmentIndex] == 0) {
            contact = [self.muyunContacts objectAtIndex:indexPath.row];
        } else {
            contact = [self.favoriteContacts objectAtIndex:indexPath.row];
        }
        [cell.nameLabel setText:[contact valueForKey:@"name"]];
        [cell.companyLabel setText:[contact valueForKey:@"company"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[contact valueForKey:@"portraitUrl"]] placeholderImage:nil];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if (indexPath.section == 0) {
        IMYMuyunViewController *muyunVC = [self.storyboard instantiateViewControllerWithIdentifier:@"muyunVC"];
        [self.navigationController pushViewController:muyunVC animated:YES];
    } else {
        IMYContactDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactDetail"];
        // ...
        // Pass the selected object to the new view controller.
        NSDictionary *contact;
        if ([self.contactsTypeSegment selectedSegmentIndex] == 0) {
            contact = [self.muyunContacts objectAtIndex:indexPath.row];
        } else {
            contact = [self.favoriteContacts objectAtIndex:indexPath.row];
        }
        
        [detailViewController setContact:contact];
        
        [self.navigationController pushViewController:detailViewController animated:YES];

    }
    
}

#pragma mark - Invited Methods

- (IBAction)tapInvitedButton:(id)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentModalViewController:peoplePicker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    //get the person name
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    self.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    //get the phone number array
    self.phonesArray = [[NSMutableArray alloc] init];
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        NSString *phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        [self.phonesArray addObject:phone];
    }
    
    //get the email array
    self.emailsArray = [[NSMutableArray alloc] init];
    ABMultiValueRef emails = ABRecordCopyValue(person,kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(emails); i++) {
        NSString *email = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(emails, 0);
        [self.emailsArray addObject:email];
    }
    
    // init the action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.title = [NSString stringWithFormat:@"Invite %@ to iMuyun", self.fullName];
   
    for (NSString* phone in self.phonesArray) {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"phone %@", phone]];
    }
    for (NSString* email in self.emailsArray) {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"email %@", email]];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:([self.phonesArray count] + [self.emailsArray count])];
    
    [actionSheet showInView:peoplePicker.view];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)inviteWithEmailAddress:(NSString *)emailAddress
{
    if ([MFMailComposeViewController canSendMail]   )
    {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setToRecipients:[NSArray arrayWithObject:emailAddress]];
        [mailVC setSubject:@"Invite you iMuyun"];
        [mailVC setMessageBody:@"Click the follow link to join in us right now" isHTML:NO];
        
        [mailVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        if (mailVC) {      
            [self presentModalViewController:mailVC animated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your device can not send email now." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }

    
}

- (void)inviteWithPhoneNumber:(NSString *)phoneNumber
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        [messageVC setRecipients:[NSArray arrayWithObject:phoneNumber]];
        [messageVC setTitle:@"Invite you iMuyun"];
        [messageVC setBody:@"Click the follow link to join in us right now"];
        [messageVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self presentModalViewController:messageVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your device can not send message now." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

/*!
 @method     messageComposeViewController:didFinishWithResult:
 @abstract   Delegate callback which is called upon user's completion of message composition.
 @discussion This delegate callback will be called when the user completes the message composition.
 How the user chose to complete this task will be given as one of the parameters to the
 callback.  Upon this call, the client should remove the view associated with the controller,
 typically by dismissing modally.
 @param      controller   The MFMessageComposeViewController instance which is returning the result.
 @param      result       MessageComposeResult indicating how the user chose to complete the composition process.
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.phonesArray count] != 0 && buttonIndex < [self.phonesArray count]) {
        [self inviteWithPhoneNumber:[self.phonesArray objectAtIndex:buttonIndex]];
    } else if ([self.emailsArray count] != 0
               && buttonIndex >= [self.phonesArray count]
               && buttonIndex < ([self.phonesArray count] + [self.emailsArray count])) {
        [self inviteWithEmailAddress:[self.emailsArray objectAtIndex:(buttonIndex - [self.phonesArray count])]];
    }
}

@end
