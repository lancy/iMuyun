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

@end

@implementation IMYContactDetailViewController
@synthesize portraitImageView;
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
    
    // init ui
    [self.nameLabel setText:[self.contact valueForKey:@"name"]];
    [self.companyLabel setText:[self.contact valueForKey:@"company"]];
    [self.portraitImageView setImageWithURL:[self.contact valueForKey:@"portraitUrl"] placeholderImage:nil];
    [self.navigationItem setTitle:[self.contact valueForKey:@"name"]];
    
}

- (void)viewDidUnload
{
    [self setPortraitImageView:nil];
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

- (IBAction)tapFavoriteButton:(id)sender {
    NSLog(@"tap favorite button");
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
@end
