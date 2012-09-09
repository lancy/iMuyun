//
//  IMYLoginViewController.m
//  iMuyun
//
//  Created by lancy on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IMYLoginViewController.h"
#import "MBProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "IMYAppDelegate.h"
#import "JMTabView.h"



@interface IMYLoginViewController ()

@end

@implementation IMYLoginViewController
//@synthesize usernameTextField;
//@synthesize passwordTextField;
@synthesize moveView;

- (void)autoLogin
{
    NSLog(@"Begin auto login. \n my info = %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"]);
    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
    if (username) {
        NSError *error;
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"iMuyun" error:&error];
        [[IMYHttpClient shareClient] requestLoginWithUsername:username password:password delegate:self];
    } else {
    }
}



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
    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];
    [self.usernameTextField setText:username];

    [self autoLogin];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setMoveView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.moveView setFrame:CGRectMake(0, 50, 320, 480)];
    [self.moveView setAlpha:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:1 animations:^{
        [self.moveView setFrame:CGRectMake(0, 0, 320, 480)];
        [self.moveView setAlpha:1];
    }];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)tapTheLoginButton:(id)sender {
    [self.passwordTextField resignFirstResponder];
    
    [[IMYHttpClient shareClient] requestLoginWithUsername:self.usernameTextField.text 
                                                 password:self.passwordTextField.text 
                                                 delegate:self];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"Login...";
}

- (IBAction)didEndEditUsername:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}


#pragma mark - http methods;

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"login"]) {
        if ([[results valueForKey:@"message"] isEqualToString:@"success"]) {
            NSString *username = self.usernameTextField.text;
            NSString *password = self.passwordTextField.text;
            NSError *error;
            [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"iMuyun" updateExisting:TRUE error:&error];
            NSLog(@"Did store username: %@ and password: %@", username, password);
            
            [[IMYHttpClient shareClient] requestUserInfoWithUsername:username delegate:self];
            
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
    else if ([[results valueForKey:@"requestType"] isEqualToString:@"userInfo"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:[results valueForKey:@"userInfo"] forKey:@"myInfo"];
        [self performSegueWithIdentifier:@"login" sender:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
   NSError *error = [request error];
    NSLog(@"Request Failed, %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"login"]) {
        IMYAppDelegate *delegate =  (IMYAppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabbarController = segue.destinationViewController;
        delegate.tabBarController = segue.destinationViewController;
        
        // add custom tabbar to original
//        JMTabView * tabView = [[JMTabView alloc] initWithFrame:tabbarController.tabBar.frame];
//        
//        [tabView setDelegate:delegate];
//        
//        [tabView addTabItemWithTitle:@"One" icon:[UIImage imageNamed:@"contacts_sel.png"]];
//        [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
//        [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
//                
//        [tabView setSelectedIndex:0];
//        
//        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bg"]];
//        
//        
//        UIImage *im = [UIImage imageNamed:@"tabbar_bg"];
//        tabbarController.tabBar.layer.contents = (__bridge id)(im.CGImage);
//        [tabbarController.tabBar insertSubview:img atIndex:1];

        
        // hide original uitabbar
//        CGRect rect = tabbarController.tabBar.frame;
//        rect.origin.y = 480;
//        [tabbarController.tabBar setFrame:rect];
//        
//        for(UIView *view in tabbarController.view.subviews)
//        {
//            CGRect _rect = view.frame;
//            if([view isKindOfClass:[UITabBar class]])
//            {
//                    _rect.origin.y = 480;
//                    [view setFrame:_rect];
//            } else {
//                    _rect.size.height = 480;
//                    [view setFrame:_rect];
//            }
//        }
    }
}

@end
