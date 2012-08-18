//
//  IMYTabBarController.m
//  iMuyun
//
//  Created by Lancy on 19/8/12.
//
//

#import "IMYTabBarController.h"
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"
#import "UIView+Positioning.h"

@interface IMYTabBarController ()

@end

@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"background.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation IMYTabBarController


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
    
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 51., self.view.bounds.size.width, 51.)];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [tabView setDelegate:self];
    
    UIImage * contactsUns = [UIImage imageNamed:@"contacts_uns"];
    UIImage * contactsSel = [UIImage imageNamed:@"contacts_sel"];
    UIImage * recentsUns = [UIImage imageNamed:@"recent_uns"];
    UIImage * recentsSel = [UIImage imageNamed:@"recent_sel"];
    UIImage * settingUns = [UIImage imageNamed:@"setting_uns"];
    UIImage * settingSel = [UIImage imageNamed:@"setting_sel"];

    
    CustomTabItem * tabItem1 = [CustomTabItem tabItemWithTitle:nil icon:contactsUns alternateIcon:contactsSel];
    CustomTabItem * tabItem2 = [CustomTabItem tabItemWithTitle:nil icon:recentsUns alternateIcon:recentsSel];
    CustomTabItem * tabItem3 = [CustomTabItem tabItemWithTitle:nil icon:settingUns alternateIcon:settingSel];
    
    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
    [tabView addTabItem:tabItem3];
    
//    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setSelectionView:nil];
    [tabView setItemSpacing:30.0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bg"]];
    [tabView setBackgroundLayer:imageView.layer];
//    [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] init]];
    
    [tabView setSelectedIndex:0];

    [self.view addSubview:tabView];
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


#pragma mark - JM Tabview delegate
-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);
    [self setSelectedIndex:itemIndex];  
}



@end


