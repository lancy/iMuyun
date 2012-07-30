//
//  IMYRecentsViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYRecentsViewController.h"
#import "IMYHttpClient.h"
#import "IMYRecordCell.h"
#import "IMYContactDetailViewController.h"
#import "IMYVideoCallViewController.h"

@interface IMYRecentsViewController ()

@property (nonatomic, strong) NSMutableArray* allRecents;
@property (nonatomic, strong) NSMutableArray* missedRecents;

@end

@implementation IMYRecentsViewController
@synthesize recentsTypeSegment = _recentsTypeSegment;
@synthesize allRecents = _allRecents;
@synthesize missedRecents = _missedRecents;

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
    [[IMYHttpClient shareClient] requestRecentsWithUsername:myUserName delegate:self];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidUnload
{
    [self setRecentsTypeSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - http methods

- (void)getMissedResultFromAllRecents
{
    NSMutableArray *missed = [[NSMutableArray alloc] init];
    for (NSDictionary *record in self.allRecents) {
        if ([[record valueForKey:@"type"] isEqualToString:@"missed"]) {
            [missed addObject:record];
        }
    }
    self.missedRecents = missed;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"%@", result);
    if ([[result valueForKey:@"requestType"] isEqualToString:@"recents"] ) {
        if (![self.allRecents isEqualToArray:[result valueForKey:@"records"]]) {
            self.allRecents = [NSMutableArray arrayWithArray:[result valueForKey:@"records"]];
            [self getMissedResultFromAllRecents];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

#pragma mark - UI methods
- (IBAction)changeRecentsTypeSegmentValue:(id)sender {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - transform methods
- (NSString *)dateStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    
    return [dayFormatter stringFromDate:date];
}


- (NSString *)timeStringFromNSDate:(NSDate *)date
{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
    [dayFormatter setLocale:[NSLocale currentLocale]];
    [dayFormatter setDateStyle:NSDateFormatterFullStyle];
    [dayFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dayFormatter setDoesRelativeDateFormatting:YES];
    return [dayFormatter stringFromDate:date];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
        return [self.allRecents count];
    } else {
        return [self.missedRecents count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recordCell";
    IMYRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *record;
    if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
        record = [self.allRecents objectAtIndex:indexPath.row];
    } else {
        record = [self.missedRecents objectAtIndex:indexPath.row];
    }
    
    UIImage *typeImage = [UIImage imageNamed:[record valueForKey:@"type"]];
    [cell.typeImageView setImage:typeImage];
    [cell.nameLabel setText:[[record valueForKey:@"contact"] valueForKey:@"name"]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *date = [dateFormat dateFromString:[record valueForKey:@"startTime"]];
    [cell.infoLabel setText:[self timeStringFromNSDate:date]];
        
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
    IMYVideoCallViewController *videoCallViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoCallViewController"];
    NSDictionary *contact;
    if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
        contact = [[self.allRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
    } else {
        contact = [[self.missedRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
    }
    [videoCallViewController setTargetContact:contact];
    [videoCallViewController setVideoCallState:IMYVideoCallStateCallOut];
    [self presentModalViewController:videoCallViewController animated:YES];
    
    
}
- (IBAction)accessoryButtonTapped:(id)sender forEvent:(UIEvent *)event
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:self.tableView]];
    NSLog(@"accessory button tapped, index path = %@", indexPath);
    
    
    
    IMYContactDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactDetail"];
    // ...
    // Pass the selected object to the new view controller.
    NSDictionary *contact;
    if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
        contact = [[self.allRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
    } else {
        contact = [[self.missedRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
    }
    
    [detailViewController setContact:contact];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    IMYContactDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactDetail"];
//    // ...
//    // Pass the selected object to the new view controller.
//    NSDictionary *contact;
//    if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
//        contact = [[self.allRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
//    } else {
//        contact = [[self.missedRecents objectAtIndex:indexPath.row] valueForKey:@"contact"];
//    }
//    
//    [detailViewController setContact:contact];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.recentsTypeSegment selectedSegmentIndex] == 0) {
            [self.allRecents removeObjectAtIndex:indexPath.row];
            [self getMissedResultFromAllRecents];
        } else {
            NSDictionary *contact = [self.missedRecents objectAtIndex:indexPath.row];
            for (NSInteger i = 0; i < self.allRecents.count; i++) {
                if ([[self.allRecents objectAtIndex:i] isEqual:contact]) {
                    [self.allRecents removeObjectAtIndex:i];
                    [self getMissedResultFromAllRecents];
                    break;
                }
            }
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
#warning need a http methods
        // request to delegate
    }
}



@end
