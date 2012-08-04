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
#import "IMYVideoCallViewController.h"

@interface IMYContactsViewController ()

// muyun contacts and favoirte contacts
@property (strong, nonatomic) NSMutableArray *muyunContacts;
@property (strong, nonatomic) NSMutableArray *favoriteContacts;


// selected contact full name phones and emails array;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSMutableArray *phonesArray;
@property (strong, nonatomic) NSMutableArray *emailsArray;

// search property
@property (strong, nonatomic) NSMutableArray *searchResults;

- (void)handleSearchForTerm:(NSString *)searchTerm;

- (void)initSearchBar;


@end

@implementation IMYContactsViewController

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
    
    NSString *myUserName = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
    [[IMYHttpClient shareClient] requestContactsWithUsername:myUserName delegate:self];
    
    // add observer
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:@"muyunContacts" options:NSKeyValueObservingOptionNew context:NULL];
    
    // init data
    self.muyunContacts = [[NSMutableArray alloc] initWithArray:[defaults valueForKey:@"muyunContacts"]];
    [self getFavoriteContactsFromMuyunContacts];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setContactsTypeSegment:nil];
    [self setSearchResults:nil];
    [self setEmailsArray:nil];
    [self setPhonesArray:nil];
    [self setFullName:nil];
    [self setMuyunContacts:nil];
    [self setFavoriteContacts:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - search methods

- (void)handleSearchForTerm:(NSString *)searchTerm
{	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];
    }
	
    [[self searchResults] removeAllObjects];
	
    if ([searchTerm length] != 0)
    {
        for (NSDictionary *contact in [self muyunContacts])
        {
            if ([[contact valueForKey:@"name"] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound
            || [[contact valueForKey:@"company"] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound
                )
            {
                [[self searchResults] addObject:contact];
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString length] > 0) {
        [self handleSearchForTerm:searchString];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

#pragma mark - contacts methods

- (void)getFavoriteContactsFromMuyunContacts
{
    NSMutableArray *favorite = [[NSMutableArray alloc] init];
    for (NSDictionary *contact in self.muyunContacts) {
        if ([[contact valueForKey:@"isFavorite"] isEqualToString:@"Yes"]){
            [favorite addObject:contact];
        }
    }
    self.favoriteContacts = favorite;
    
}

#pragma mark - Http request methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"contacts"] ) {
        if (![self.muyunContacts isEqualToArray:[results valueForKey:@"contacts"]]) {
            NSLog(@"Results are different, will write to userdefaults buffer muyunContacts."); 
            [[NSUserDefaults standardUserDefaults] setValue:[results valueForKey:@"contacts"] forKey:@"muyunContacts"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"Did write to user defaults buffer muyunContacts.");
        }
    } 
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request failed, %@", error);
}


#pragma mark - Observer methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"muyunContacts"]) {
        NSLog(@"Observe that userdefaults buffer muyunContacts change to: %@", [change objectForKey:NSKeyValueChangeNewKey]);
        if (![self.muyunContacts isEqual:[change objectForKey:NSKeyValueChangeNewKey]]){
            NSLog(@"Change are different, will modify self.muyunContacts and self.favoriteContacts");
            if ([[change objectForKey:NSKeyValueChangeNewKey] isKindOfClass:[NSArray class]]) {
                self.muyunContacts = [[NSMutableArray alloc] initWithArray:[change objectForKey:NSKeyValueChangeNewKey]];
                [self getFavoriteContactsFromMuyunContacts];
                
            } else
            {
                self.muyunContacts = nil;
                self.favoriteContacts = nil;
            }
            NSLog(@"Did modified self.muyunContacts and self.favoriteContacts.");
        }
    }
    
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
    //    [super observeValueForKeyPath:keyPath
    //                         ofObject:object
    //                           change:change
    //                          context:context];
}

#pragma mark - UI methods

- (IBAction)changeContactTypeSegmentValue:(id)sender
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"Did changed contact type segment controller");
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self.searchDisplayController isActive]) {
        return 1;
    } else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.searchDisplayController isActive]) {
        if (self.searchResults) {
            return [self.searchResults count];
        } else {
            return 0;
        }
    } else
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
    IMYContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if ([self.searchDisplayController isActive]) {
        NSDictionary *contact;
        if (self.searchResults) {
            contact = [self.searchResults objectAtIndex:indexPath.row];
            [cell.nameLabel setText:[contact valueForKey:@"name"]];
            [cell.companyLabel setText:[contact valueForKey:@"company"]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:[contact valueForKey:@"portraitUrl"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
        }
    } else

    if (indexPath.section == 0) {
        [cell.nameLabel setText:@"Muyun Interpreter"];
        [cell.companyLabel setText:@"Muyun Company"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://www.imuyun.com/themes/classic/img/favicon.ico"] placeholderImage:[UIImage imageNamed:@"avatar"]];
    } else {
        NSDictionary *contact;
        if ([self.contactsTypeSegment selectedSegmentIndex] == 0) {
            contact = [self.muyunContacts objectAtIndex:indexPath.row];
        } else {
            contact = [self.favoriteContacts objectAtIndex:indexPath.row];
        }
        [cell.nameLabel setText:[contact valueForKey:@"name"]];
        [cell.companyLabel setText:[contact valueForKey:@"company"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[contact valueForKey:@"portraitUrl"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([self.searchDisplayController isActive]) {
        IMYContactDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactDetail"];
        // ...
        // Pass the selected object to the new view controller.
        NSDictionary *contact;
        contact = [self.searchResults objectAtIndex:indexPath.row];
        
        [detailViewController setContact:contact];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else 
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


- (IBAction)phoneButtonTapped:(id)sender forEvent:(UIEvent *)event
{
    UITableView *tableView;
    if ([self.searchDisplayController isActive]) {
        tableView = self.searchDisplayController.searchResultsTableView;
    } else
    {
        tableView = self.tableView;
    }
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:tableView]];
    NSLog(@"phone button tapped, index path = %@", indexPath);
    
    IMYVideoCallViewController *videoCallViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoCallViewController"];
    
    NSDictionary *contact;
    if ([self.searchDisplayController isActive]) {
        contact = [self.searchResults objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 0) {
    }
    else if ([self.contactsTypeSegment selectedSegmentIndex] == 0) {
        contact = [self.muyunContacts objectAtIndex:indexPath.row];
    } else {
        contact = [self.favoriteContacts objectAtIndex:indexPath.row];
    }

    [videoCallViewController setTargetContact:contact];
    [videoCallViewController setVideoCallState:IMYVideoCallStateCallOut];
    [self presentModalViewController:videoCallViewController animated:YES];

    
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"accessory button tap");
//}

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
    self.fullName = @"";
    if (firstName != nil) {
        self.fullName = [self.fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        self.fullName = [self.fullName stringByAppendingString:lastName];
    }
    
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
            [self.presentedViewController presentModalViewController:mailVC animated:YES];
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
        
        [self.presentedViewController presentModalViewController:messageVC animated:YES];
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
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
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
