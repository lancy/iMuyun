//
//  IMYMuyunViewController.m
//  iMuyun
//
//  Created by Lancy on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYMuyunViewController.h"
#import "IMYInterpreterVideoCallViewController.h"

@interface IMYMuyunViewController ()

@end

@implementation IMYMuyunViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)tapVideoCallButton:(id)sender {
    IMYInterpreterVideoCallViewController *interpreterVideoCallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"interpreterVideoCallViewController"];
    
    [interpreterVideoCallVC setMyLanguage:@"Chinese"];
    [interpreterVideoCallVC setTargetLanguage:@"1"];
    [interpreterVideoCallVC setVideoCallState:IMYVideoCallStateCallOut];
    
    [self presentViewController:interpreterVideoCallVC animated:YES completion:nil];

}
@end
