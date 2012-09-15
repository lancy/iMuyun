//
//  IMYFeedBackViewController.m
//  iMuyun
//
//  Created by Lancy on 10/9/12.
//
//

#import "IMYFeedBackViewController.h"
#import "MBProgressHUD.h"
#import "IMYHttpClient.h"

@interface IMYFeedBackViewController()

@property (nonatomic, strong) UITextView *feedBackTextView;


- (void)creatUserinterface;
- (IBAction)tapSendButton:(id)sender;

@end

@implementation IMYFeedBackViewController

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
    
    [self creatUserinterface];
    [self.feedBackTextView becomeFirstResponder];

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

#pragma mark - UI Methods
- (void)creatUserinterface
{
    [self setTitle:@"Feedback"];
    
    // feedback TextView
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg2"]];
    [background setFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:background];
    
    self.feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 280, 150)];
    [self.feedBackTextView setBackgroundColor:[UIColor clearColor]];
    [self.feedBackTextView setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.view addSubview:self.feedBackTextView];
    CGRect frame = self.feedBackTextView.frame;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - 5, frame.size.width, frame.size.height + 10)];
    imgView.image = [[UIImage imageNamed: @"contacts_note"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    // add border corner and shadow
    //    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.masksToBounds= NO;
    //    imgView.layer.cornerRadius= 5.0f;
    //    imgView.layer.borderWidth = 2.0f;
    
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(0, 2);
    imgView.layer.shadowOpacity = 0.5;
    imgView.layer.shadowRadius = 2.0;
    
    [self.view insertSubview:imgView belowSubview:self.feedBackTextView];
    
    
    // add send button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(tapSendButton:)]];

}

- (IBAction)tapSendButton:(id)sender
{
    NSLog(@"User tap send button");
    [self.feedBackTextView resignFirstResponder];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hub setLabelText:@"Sending"];
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] valueForKey:@"myInfo"] valueForKey:@"username"];

    [[IMYHttpClient shareClient] requestSendFeedBackWithUsername:username message:self.feedBackTextView.text deleagte:self];
}

#pragma mark - Http request methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
    NSLog(@"Request finished, results: %@", results);
    if ([[results valueForKey:@"requestType"] isEqualToString:@"sendFeedBack"]) {
        if ([[results valueForKey:@"message"] isEqualToString:@"success"])
        {
            NSLog(@"Send feedback success");
            [[MBProgressHUD HUDForView:self.view] setMode:MBProgressHUDModeText];
            [[MBProgressHUD HUDForView:self.view] setLabelText:@"Success"];
            [[MBProgressHUD HUDForView:self.view] hide:YES afterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"Send feedback fail");
            [[MBProgressHUD HUDForView:self.view] setMode:MBProgressHUDModeText];
            [[MBProgressHUD HUDForView:self.view] setLabelText:@"Fail"];
            [[MBProgressHUD HUDForView:self.view] hide:YES afterDelay:1.0];
//            [MBProgressHUD hideHUDForView:self.view animated:];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Request failed, %@", error);
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[MBProgressHUD HUDForView:self.view] setMode:MBProgressHUDModeText];
    [[MBProgressHUD HUDForView:self.view] setLabelText:@"Network Error"];
    [[MBProgressHUD HUDForView:self.view] hide:YES afterDelay:1.0];

}



@end
