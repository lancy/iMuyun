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

@property (nonatomic, strong) NSArray *languageArray;

@end

@implementation IMYRegisterViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize repeatTextField;
@synthesize languageTextField;

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
    self.languageArray = LANGUAGE_ARRAY;
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLanguageArray:nil];
    [self setLanguageTextField:nil];
    [self setRepeatTextField:nil];
    [self setLanguagePickerView:nil];
    [self setLanguageInputAccessoryView:nil];

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
    if ([self.passwordTextField.text isEqualToString:self.repeatTextField.text]) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.labelText = @"Sign up...";
        
        [[IMYHttpClient shareClient] requestRegisterWithUsername:self.usernameTextField.text password:self.passwordTextField.text language:self.languageTextField.text delegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something wrong" message:@"Password repeat incorrect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)languagePickerTapDoneButton:(id)sender {
    NSString *language = [self.languageArray objectAtIndex:[self.languagePickerView selectedRowInComponent:0]];
    [self.languageTextField setText:language];
    [self.languageTextField resignFirstResponder];
}

#pragma mark - language picker delegate methods

- (IBAction)didEndOnExit:(id)sender {
    [self resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.languageArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.languageArray objectAtIndex:row];
}

#pragma mark - textfield delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.languageTextField) {
        if (textField.inputView == nil) {
            textField.inputView = self.languagePickerView;
        }
        if (textField.inputAccessoryView == nil)
        {
            textField.inputAccessoryView = self.languageInputAccessoryView;
        }
        
    }
    return YES;
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
