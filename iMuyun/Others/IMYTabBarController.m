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
    
    self.jmTabview = tabView;

    [self.view addSubview:tabView];
    
    
    // observer push events
    for (UINavigationController *navi in self.viewControllers) {
        navi.delegate = self;
    }
    
//    [self.tabBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:NULL];
//    [self.tabBar addObserver:self forKeyPath:@"hidesBottomBarWhenPushed" options:NSKeyValueObservingOptionNew context:nil];
    
    
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


