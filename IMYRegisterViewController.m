//
//  IMYRegisterViewController.m
//  iMuyun
//
//  Created by Lancy on 7/8/12.
//
//

#import "IMYRegisterViewController.h"
#import "MBProgressHUD.h"
#import "IMYLoginViewController.h"

@interface IMYRegisterViewController ()

@end

@implementation IMYRegisterViewController
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

#pragma mark - UI Methods
- (IBAction)tapBackButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tapSignUpButton:(id)sender {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"Sign up...";
    [[IMYHttpClient shareClient]requestRegisterWithUsername:self.usernameTextField.text password:self.passwordTextField.text delegate:self];
}

#pragma mark - Http methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"register"]) {
        if ([[results valueForKey:@"message"] isEqualToString:@"success"]) {
            NSLog(@"Register success");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            IMYLoginViewController *loginViewController = (IMYLoginViewController *)[self presentingViewController];
            [loginViewController.usernameTextField setText:self.usernameTextField.text];
            [loginViewController.passwordTextField setText:self.passwordTextField.text];
            [loginViewController tapTheLoginButton:self];
            
            [self dismissModalViewControllerAnimated:YES];
        } else {
            NSLog(@"Register fail");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
//    else if ([[results valueForKey:@"requestType"] isEqualToString:@"userInfo"])
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:[results valueForKey:@"userInfo"] forKey:@"myInfo"];
//        [self performSegueWithIdentifier:@"login" sender:self];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request Failed, %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
