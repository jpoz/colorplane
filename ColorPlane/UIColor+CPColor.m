//
//  UIColor+CPColor.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/13/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "UIColor+CPColor.h"

@implementation UIColor (CPColor)

+ (UIColor*)randomColor {
    
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    
    NSInteger buckets = floorf((kCPColorChannelResolution*0.01)*255.0);
    
    r = floorf(((float)buckets/255.0)*(float)r);
    g = floorf(((float)buckets/255.0)*(float)g);
    b = floorf(((float)buckets/255.0)*(float)b);
    
    CGFloat factor = 255.0/(float)buckets;
    
    r = floor(factor*(float)r);
    g = floor(factor*(float)g);
    b = floor(factor*(float)b);
    
    NSLog(@"Random Color: %d %d %d", r, g, b);
    
    return [UIColor colorWithRed:((float)r/255.0)
                           green:((float)g/255.0)
                            blue:((float)b/255.0)
                           alpha:1.0];
}

@end
