//
//  CPTargetView.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/12/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPTargetView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CPTargetView

- (void)commonInit {
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"target_mask.png"] CGImage];
    self.layer.mask = maskLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
 
        [self commonInit];
    }
    
    return self;
}

- (void)setTargetColor:(UIColor*)targetColor {
    self.backgroundColor = targetColor;
}

- (UIColor*)targetColor {
    return self.backgroundColor;
}

@end
