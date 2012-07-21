//
//  IMYLoginViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYLoginViewController.h"

@interface IMYLoginViewController ()

@end

@implementation IMYLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;

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
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)tapTheLoginButton:(id)sender {
    [[IMYHttpClient shareClient] requestLoginWithUsername:self.usernameTextField.text 
                                                 password:self.passwordTextField.text 
                                                 delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *resultString = [request responseString];
    NSLog(@"%@", resultString);
//    NSError *error;
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
}

@end
