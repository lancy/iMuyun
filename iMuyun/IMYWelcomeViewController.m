//
//  IMYWelcomeViewController.m
//  iMuyun
//
//  Created by Lancy on 14/10/12.
//
//

#import "IMYWelcomeViewController.h"

@interface IMYWelcomeViewController ()

@end

@implementation IMYWelcomeViewController

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
    
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"firstEnter"];
    
    [self.scrollView setDelegate:self];
    
    NSUInteger pageCount = 3;
    CGSize viewSize = self.view.frame.size;
    [self.scrollView setContentSize:CGSizeMake(viewSize.width * pageCount, viewSize.height)];
    
    CGRect frame = self.scrollView.frame;
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, viewSize.width - 40, 60)];
    [firstLabel setText:@"It's expensive and inconvenient with personal interpreter before."];
    [firstLabel setNumberOfLines:2];
    [firstLabel setTextAlignment:NSTextAlignmentCenter];
    [firstLabel setTextColor:[UIColor whiteColor]];
    [firstLabel setBackgroundColor:[UIColor clearColor]];
    [firstView addSubview:firstLabel];
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial1"]];
    [firstImageView setFrame:CGRectMake(45, 230, 230, 160)];
    [firstView addSubview:firstImageView];
    
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [firstView setFrame:frame];
    [self.scrollView addSubview:firstView];
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, viewSize.width - 40, 60)];
    [secondLabel setText:@"But it's efficient and simple with remote video interpreter now."];
    [secondLabel setNumberOfLines:2];
    [secondLabel setTextColor:[UIColor whiteColor]];
    [secondLabel setBackgroundColor:[UIColor clearColor]];
    [secondLabel setTextAlignment:NSTextAlignmentCenter];
    [secondView addSubview:secondLabel];
    UIImageView *secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial2"]];
    [secondImageView setFrame:CGRectMake(69, 253, 182, 137)];
    [secondView addSubview:secondImageView];
    
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [secondView setFrame:frame];
    [self.scrollView addSubview:secondView];
    
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, viewSize.width - 40, 60)];
    [thirdLabel setText:@"iMuyun Remote Video Interpreter\n make translation readily available."];
    [thirdLabel setTextAlignment:NSTextAlignmentCenter];
    [thirdLabel setNumberOfLines:2];
    [thirdLabel setTextColor:[UIColor whiteColor]];
    [thirdLabel setBackgroundColor:[UIColor clearColor]];
    [thirdView addSubview:thirdLabel];
    UIImageView *thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icondraw"]];
    [thirdImageView setFrame:CGRectMake(113, 220, 93, 90)];
    [thirdView addSubview:thirdImageView];

    
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, 280, 37)];
    [enterButton setTitle:@"Enter iMuyun" forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(tapEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    [thirdView addSubview:enterButton];
    
    
    frame.origin.x = frame.size.width * 2;
    frame.origin.y = 0;
    [thirdView setFrame:frame];
    [self.scrollView addSubview:thirdView];



}

- (void)tapEnterButton:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
@end
