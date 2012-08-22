//  Created by Jason Morrissey

#import "CustomBackgroundLayer.h"
#import "UIColor+Hex.h"

@implementation CustomBackgroundLayer

-(id)init;
{
    self = [super init];
    if (self)
    {
//        CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
//        UIColor * startColor = [UIColor colorWithHex:0x4a4b4a];
//        UIColor * midColor = [UIColor colorWithHex:0x282928];
//        UIColor * endColor = [UIColor colorWithHex:0x4a4b4a];
//        gradientLayer.frame = CGRectMake(0, 0, 1024, 60);
//        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[midColor CGColor], (id)[endColor CGColor], nil];
//        [self insertSublayer:gradientLayer atIndex:0];
        

        
        
        CAGradientLayer *grendientLayer = [[CAGradientLayer alloc] init];
        UIColor *greenColor = [UIColor colorWithRed:81.0/255.0 green:178.0/255.0 blue:56.0/255.0 alpha:1.0];
        grendientLayer.frame = CGRectMake(0, 0, 320, 49);
        grendientLayer.colors = [NSArray arrayWithObjects:(id)[greenColor CGColor], (id)[greenColor CGColor], (id)[greenColor CGColor], nil];
        [self insertSublayer:grendientLayer atIndex:0];
        
        CAGradientLayer *grayLayer = [[CAGradientLayer alloc] init];
        UIColor *lightGrayColor = [UIColor lightGrayColor];
        UIColor *grayColor = [UIColor grayColor];
        grayLayer.frame = CGRectMake(0, 0, 320, 3);
        grayLayer.colors = [NSArray arrayWithObjects:(id)[lightGrayColor CGColor], (id)[grayColor CGColor], (id)[grayColor CGColor], nil];
        grayLayer.shadowColor = [UIColor blackColor].CGColor;
        grayLayer.shadowOffset = CGSizeMake(0, 1);
        grayLayer.shadowOpacity = 0.5;
        grayLayer.shadowRadius = 2.0;
        
        [self insertSublayer:grayLayer atIndex:1];
        
        
//        [self setMasksToBounds:NO];
//        CAGradientLayer * shadeLayer = [[CAGradientLayer alloc] init];
//        UIColor * startColor = [UIColor colorWithHex:0x4a4b4a];
//        UIColor * midColor = [UIColor colorWithHex:0x282928];
//        UIColor * endColor = [UIColor colorWithHex:0x4a4b4a];
//        shadeLayer.frame = CGRectMake(0, 0, 320, 30);
//        shadeLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[midColor CGColor], (id)[endColor CGColor], nil];
//        [self insertSublayer:shadeLayer atIndex:2];
        
        
        

    }
    return self;
}

@end
