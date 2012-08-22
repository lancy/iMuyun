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
#import "UINavigationBar+DropShadow.h"

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
    
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49., self.view.bounds.size.width, 49.)];
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
    
    CustomSelectionView *selectView = [CustomSelectionView createSelectionView];
    [selectView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [selectView.layer setShadowOffset:CGSizeMake(0, 3)];
    [selectView.layer setShadowOpacity:0.7];
    [selectView.layer setShadowRadius:1.0];
    
    [tabView setSelectionView:selectView];
    
    
    [tabView setItemSpacing:30.0];
    CALayer *tabbarBg = [[CALayer alloc] init];
    [tabbarBg setFrame:CGRectMake(0, 0, 320, 49)];

    
    tabbarBg.contents = (id)[UIImage imageNamed:@"tabbar_bg"].CGImage;
//    [tabView setBackgroundLayer:tabbarBg];
    
    
    [tabView.layer setMasksToBounds:NO];
    

    [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] init]];

    [tabView setSelectedIndex:0];
    
    self.jmTabview = tabView;

    [self.view addSubview:tabView];
    
    
    // observer push events and drop shadow
    for (UINavigationController *navi in self.viewControllers) {
        navi.delegate = self;
//        [navi.navigationBar dropShadowWithOffset:CGSizeMake(0, 2) radius:1 color:[UIColor lightGrayColor] opacity:.5];
    }

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Observer methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"hidden"]) {
        NSNumber *toggle = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"Observe tabbar hidden change to: %@", change);
        
        CGRect rect = self.jmTabview.frame;
        NSLog(@"%f", self.jmTabview.frame.origin.y);
        if (toggle.intValue == 1) {
            [UIView animateWithDuration:0.1 animations:^{
                [self.jmTabview setFrame:CGRectMake(rect.origin.x, rect.origin.y + 51, rect.size.width, rect.size.height)];
            }];
        } else {
            [self.jmTabview setFrame:CGRectMake(rect.origin.x - 320, rect.origin.y - 51, rect.size.width, rect.size.height)];

            [UIView animateWithDuration:0.35 animations:^{
                [self.jmTabview setFrame:CGRectMake(rect.origin.x, rect.origin.y - 51, rect.size.width, rect.size.height)];
            }];
            [self.view bringSubviewToFront:self.jmTabview];
        }
        
    }
    
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
    //    [super observeValueForKeyPath:keyPath
    //                         ofObject:object
    //                           change:change
    //                          context:context];
}

#pragma mark - Navigation controller delegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        CGRect rect = self.jmTabview.frame;
        if (viewController.hidesBottomBarWhenPushed == YES) {
            [UIView animateWithDuration:0.35 animations:^{
                [self.jmTabview setFrame:CGRectMake(rect.origin.x - 320, rect.origin.y, rect.size.width, rect.size.height)];
            }];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                [self.jmTabview setFrame:CGRectMake(rect.origin.x + 320, rect.origin.y, rect.size.width, rect.size.height)];
            }];
            [self.view bringSubviewToFront:self.jmTabview];
        }
    }
}

#pragma mark - JM Tabview delegate
-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);
    [self setSelectedIndex:itemIndex];  
}



@end


