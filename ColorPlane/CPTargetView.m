//
//  CPTargetView.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/12/12.
//  Copyright (c) 2012 Notion HQ. All rights reserved.
//

#import "CPTargetView.h"
#import <QuartzCore/QuartzCore.h>

@interface CPTargetView ()

@property (nonatomic, retain) CAShapeLayer *targetColorLayer;

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
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    CGMutablePathRef targetColorPath = CGPathCreateMutable();
    CGRect targetRect = rectForTargetInFrame(self.bounds);
    CGPathAddEllipseInRect(targetColorPath, NULL, targetRect);
    
    CAShapeLayer *targetColorLayer = [CAShapeLayer layer];
    targetColorLayer.path = targetColorPath;
    targetColorLayer.fillColor = [UIColor clearColor].CGColor;
    targetColorLayer.strokeColor = [UIColor blueColor].CGColor;
    targetColorLayer.lineWidth = 35.0;
    targetColorLayer.strokeStart = 0.0;
    targetColorLayer.strokeEnd = 1.0;
    [self.layer addSublayer:targetColorLayer];
    self.targetColorLayer = targetColorLayer;
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

    self.targetColorLayer.backgroundColor = targetColor.CGColor;
}

- (UIColor*)targetColor {

    return [UIColor colorWithCGColor:self.targetColorLayer.backgroundColor];
}

- (void)startTimer:(id)sender {
    
    CABasicAnimation *timerAnimation = [CABasicAnimation animation];
    timerAnimation.duration = 60.0;
    timerAnimation.fromValue = [NSNumber numberWithInt:0.0];
    timerAnimation.toValue = [NSNumber numberWithInt:1.0];
    timerAnimation.keyPath = @"strokeStart";
    timerAnimation.fillMode = kCAFillModeForwards;
    timerAnimation.removedOnCompletion = NO;
    [self.targetColorLayer addAnimation:timerAnimation forKey:@"timerAnimation"];
}

- (void)stopTimer:(id)sender {
    
    CAShapeLayer *targetColorLayer = self.targetColorLayer;
    UIButton *button = (UIButton*)sender;
    
    if(targetColorLayer.speed == 0.0) {
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        CFTimeInterval pausedTime = [targetColorLayer timeOffset];
        targetColorLayer.speed = 1.0;
        targetColorLayer.timeOffset = 0.0;
        targetColorLayer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [targetColorLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        targetColorLayer.beginTime = timeSincePause;
    } else {
        [button setTitle:@"Resume" forState:UIControlStateNormal];
        CFTimeInterval pausedTime = [targetColorLayer convertTime:CACurrentMediaTime() fromLayer:nil];
        targetColorLayer.speed = 0.0;
        targetColorLayer.timeOffset = pausedTime;
    }
}

- (void)resetTimer:(id)sender {
    
    [self.targetColorLayer removeAnimationForKey:@"timerAnimation"];
    self.targetColorLayer.strokeStart = 0.0;
}

@end
