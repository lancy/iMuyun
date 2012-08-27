//
//  IMYContactDetailViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYContactDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "IMYVideoCallViewController.h"

@interface IMYContactDetailViewController ()

- (void)customUserInterface;

@end

@implementation IMYContactDetailViewController
@synthesize avatarImageView;
@synthesize nameLabel;
@synthesize companyLabel;
@synthesize noteTextView;
@synthesize favoriteButton;
@synthesize contact = _contact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // init datas
    [self.nameLabel setText:[self.contact valueForKey:@"name"]];
    [self.companyLabel setText:[self.contact valueForKey:@"company"]];
    [self.avatarImageView setImageWithURL:[self.contact valueForKey:@"avatarUrl"] placeholderImage:nil];
    [self.navigationItem setTitle:[self.contact valueForKey:@"name"]];
    
    if ([[self.contact valueForKey:@"isFavorite"] isEqualToString:@"Yes"]){
        [self.favoriteButton setSelected:YES];
    } else {
        [self.favoriteButton setSelected:NO];
    }
    
    // custom user interface
    [self customUserInterface];
}

- (void)viewDidUnload
{
    [self setAvatarImageView:nil];
    [self setNameLabel:nil];
    [self setCompanyLabel:nil];
    [self setNoteTextView:nil];
    [self setFavoriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI methods

- (void)customUserInterface
{
    // custom avata image view
    self.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.avatarImageView.layer.masksToBounds= NO;
    //    self.avatarImageView.layer.cornerRadius= 5.0f;
    self.avatarImageView.layer.borderWidth = 2.0f;
    
    self.avatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImageView.layer.shadowOffset = CGSizeMake(2, 2);
    self.avatarImageView.layer.shadowOpacity = 0.5;
    self.avatarImageView.layer.shadowRadius = 2.0;
    
    
    // custom noteview
    CGRect frame = self.noteTextView.frame;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - 5, frame.size.width, frame.size.height + 10)];
    imgView.image = [[UIImage imageNamed: @"contacts_note"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.view insertSubview:imgView belowSubview:self.noteTextView];
    
    // add border corner and shadow
//    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.masksToBounds= NO;
//    imgView.layer.cornerRadius= 5.0f;
//    imgView.layer.borderWidth = 2.0f;
    
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(0, 2);
    imgView.layer.shadowOpacity = 0.5;
    imgView.layer.shadowRadius = 2.0;
    
}

- (IBAction)tapFavoriteButton:(id)sender {
    NSLog(@"tap favorite button");
    BOOL toggle;
    NSString *stringToggle;
    if ([[self.contact valueForKey:@"isFavorite"] isEqualToString:@"Yes"]){
        toggle = NO;
        stringToggle = @"No";
    } else {
        toggle = YES;
        stringToggle = @"Yes";
    }
    
    
    
    // set favorite to !toggle
//    NSMutableArray *contactsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"muyunContacts"]];
//    for (NSInteger i = 0; i < [contactsArray count]; i++) {
//        if ([self.contact isEqualToDictionary:[contactsArray objectAtIndex:i]]) {
//            NSMutableDictionary *newContact = [NSMutableDictionary dictionaryWithDictionary:[contactsArray objectAtIndex:i]];
//            [newContact setValue:stringToggle forKey:@"isFavorite"];
//            [contactsArray replaceObjectAtIndex:i withObject:newContact];
//            
//            [[NSUserDefaults standardUserDefaults] setValue:contactsArray forKey:@"muyunContacts"];
//            break;
//        }
//    }
    
    [self.favoriteButton setSelected:toggle];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Yes" forKey:@"contactsNeedToReload"];

    
    NSString *myUserName = [[defaults valueForKey:@"myInfo"] valueForKey:@"username"];
    [[IMYHttpClient shareClient]requestSetFavoriteWithUsername:myUserName favoriteUsername:[self.contact valueForKey:@"username"] toggle:stringToggle delegate:self];
    
}

- (IBAction)tapMessageButton:(id)sender {
    NSLog(@"tap message button");
}

- (IBAction)tapAudioCallButton:(id)sender {
    NSLog(@"tap audio call button");
}

- (IBAction)tapVideoCallButton:(id)sender {
    NSLog(@"tap video call button");
    IMYVideoCallViewController *videoCallViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoCallViewController"];
    [videoCallViewController setTargetContact:self.contact];
    [videoCallViewController setVideoCallState:IMYVideoCallStateCallOut];
    [self presentModalViewController:videoCallViewController animated:YES];
}

#pragma mark - Http methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if([[results valueForKey:@"requestType"] isEqualToString:@"setFavorite"])
    {
        if ([[results valueForKey:@"message"] isEqualToString:@"success"]) {
            NSLog(@"Set favorite success");
        }
        else
        {
            NSLog(@"Set favorite fail");
        }
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request failed, %@", error);
}
@end
