//
//  UINavigationBar+DropShadow.h
//  iMuyun
//
//  Created by Lancy on 20/8/12.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (DropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;

@end
