//
//  CPTargetView.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/12/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPTargetView.h"
#import <QuartzCore/QuartzCore.h>

@interface CPTargetView ()

@property (nonatomic, retain) CAShapeLayer *targetColorLayer;

- (void)startTimer;
- (void)stopTimer;
- (void)resetTimer;

@end

@implementation CPTargetView

CGFloat radiusForRect(CGRect rect) {
    
    CGFloat radiusPercentageOfSize = 0.6;
    return rect.size.width > rect.size.height ? rect.size.height * radiusPercentageOfSize : rect.size.width * radiusPercentageOfSize;
}

CGRect rectForTargetInFrame(CGRect frame) {
    
    CGFloat radius = radiusForRect(frame);
    return CGRectMake(CGRectGetMinX(frame)+floorf((CGRectGetWidth(frame)-radius)/2.0),
                      CGRectGetMinY(frame)+floorf((CGRectGetHeight(frame)-radius)/2.0),
                      radius,
                      radius);
}

- (void)commonInit {
    
    CGMutablePathRef targetColorPath = CGPathCreateMutable();
    CGRect targetRect = rectForTargetInFrame(self.bounds);
    CGPathAddEllipseInRect(targetColorPath, NULL, targetRect);
    
    CAShapeLayer *targetColorLayer = [CAShapeLayer layer];
    targetColorLayer.path = targetColorPath;
    targetColorLayer.fillColor = [UIColor redColor].CGColor;
    targetColorLayer.strokeColor = [UIColor blueColor].CGColor;
    targetColorLayer.lineWidth = 10.0;
    targetColorLayer.strokeStart = 0.0;
    targetColorLayer.strokeEnd = 1.0;
    [self.layer addSublayer:targetColorLayer];
    self.targetColorLayer = targetColorLayer;
    
    [self startTimer];
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
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setTargetColor:(UIColor*)targetColor {

    self.backgroundColor = targetColor;
}

- (UIColor*)targetColor {

    return self.backgroundColor;
}

- (void)startTimer {
    
    CABasicAnimation *timerAnimation = [CABasicAnimation animation];
    timerAnimation.duration = 60.0;
    timerAnimation.fromValue = [NSNumber numberWithInt:0.0];
    timerAnimation.toValue = [NSNumber numberWithInt:1.0];
    timerAnimation.keyPath = @"strokeStart";
    [self.targetColorLayer addAnimation:timerAnimation forKey:@"timerAnimation"];
}

- (void)stopTimer {
    
    
}

- (void)resetTimer {
    
    
}

@end
