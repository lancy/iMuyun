//  Created by Jason Morrissey

#import "CustomSelectionView.h"
#import "UIView+InnerShadow.h"
#import "UIColor+Hex.h"

#define kTriangleHeight 8.

@implementation CustomSelectionView

- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1] set];
//    CGRect squareRect = CGRectOffset(rect, 0, kTriangleHeight);
//    squareRect.size.height -= kTriangleHeight;
//    UIBezierPath * squarePath = [UIBezierPath bezierPathWithRoundedRect:squareRect cornerRadius:4.];
//    [squarePath fill];
    
    
//    [[UIColor grayColor] set];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(rect.size.width / 2 - kTriangleHeight, 4)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2, kTriangleHeight + 4)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2 + kTriangleHeight, 4)];
    [trianglePath closePath];
    [trianglePath fill];
}

+ (CustomSelectionView *) createSelectionView;
{
    CustomSelectionView * selectionView = [[[CustomSelectionView alloc] initWithFrame:CGRectZero] autorelease];
    return selectionView;
}

@end
