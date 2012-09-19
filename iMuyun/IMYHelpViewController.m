//
//  IMYHelpViewController.m
//  iMuyun
//
//  Created by Lancy on 19/9/12.
//
//

#import "IMYHelpViewController.h"

@interface IMYHelpViewController ()

@end

@implementation IMYHelpViewController
@synthesize contentWebView;

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
    
    // get localized path for file from app bundle
	NSBundle *thisBundle = [NSBundle mainBundle];
	NSString *path = [thisBundle pathForResource:@"help" ofType:@"html"];
    
	// make a file: URL out of the path
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[self.contentWebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];

}

- (void)viewDidUnload
{
    [self setContentWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
