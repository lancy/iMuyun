//
//  IMYWelcomeViewController.h
//  iMuyun
//
//  Created by Lancy on 14/10/12.
//
//

#import <UIKit/UIKit.h>

@interface IMYWelcomeViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
