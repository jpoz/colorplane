//
//  CPColorMapOverlay.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 10/25/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPColorMapOverlay.h"

#define kCPEdgeUnitSize .3

typedef enum {
    CPGradientDirectionUp,
    CPGradientDirectionDown,
    CPGradientDirectionLeft,
    CPGradientDirectionRight
} CPGradientDirection;

@implementation CPColorMapOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

CGPoint startPointForDirection(CGRect rect, CPGradientDirection direction) {
    
    CGPoint startPoint;
    
    switch (direction) {
        case CPGradientDirectionUp:
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
            break;
        case CPGradientDirectionDown:
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            break;
        case CPGradientDirectionLeft:
            startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
            break;
        case CPGradientDirectionRight:
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            break;
        default:
            break;
    }
    
    return startPoint;
}

CGPoint endPointForDirection(CGRect rect, CPGradientDirection direction) {
    
    CGPoint endPoint;
    
    switch (direction) {
        case CPGradientDirectionUp:
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            break;
        case CPGradientDirectionDown:
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
            break;
        case CPGradientDirectionLeft:
            endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            break;
        case CPGradientDirectionRight:
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
            break;
        default:
            break;
    }
    
    return endPoint;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor, CPGradientDirection direction) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = startPointForDirection(rect, direction);
    CGPoint endPoint = endPointForDirection(rect, direction);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGRect leftSide = CGRectMake(CGRectGetMinX(rect),
                                 CGRectGetMinY(rect),
                                 floorf((CGRectGetWidth(rect)/2.0)*kCPEdgeUnitSize),
                                 CGRectGetHeight(rect));
    
    CGRect bottomSide = CGRectMake(CGRectGetMinX(rect),
                                   CGRectGetMaxY(rect)-floorf((CGRectGetHeight(rect)/2.0)*kCPEdgeUnitSize),
                                   CGRectGetWidth(rect),
                                   floorf((CGRectGetHeight(rect)/2.0)*kCPEdgeUnitSize));
    
    CGRect rightSide = CGRectMake(CGRectGetMaxX(rect)-floorf((CGRectGetWidth(rect)/2.0)*kCPEdgeUnitSize),
                                  CGRectGetMinY(rect),
                                  floorf((CGRectGetWidth(rect)/2.0)*kCPEdgeUnitSize),
                                  CGRectGetHeight(rect));
    
    CGRect topSide = CGRectMake(CGRectGetMinX(rect),
                                   CGRectGetMinY(rect),
                                   CGRectGetWidth(rect),
                                   floorf((CGRectGetHeight(rect)/2.0)*kCPEdgeUnitSize));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    drawLinearGradient(ctx,
                       leftSide,
                       [[[UIColor redColor] colorWithAlphaComponent:0.6] CGColor],
                       [[UIColor clearColor] CGColor],
                       CPGradientDirectionRight);
    
    drawLinearGradient(ctx,
                       bottomSide,
                       [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
                       [[UIColor clearColor] CGColor],
                       CPGradientDirectionUp);
    
    drawLinearGradient(ctx,
                       rightSide,
                       [[[UIColor blueColor] colorWithAlphaComponent:0.6] CGColor],
                       [[UIColor clearColor] CGColor],
                       CPGradientDirectionLeft);
    
    drawLinearGradient(ctx,
                       topSide,
                       [[[UIColor greenColor] colorWithAlphaComponent:0.6] CGColor],
                       [[UIColor clearColor] CGColor],
                       CPGradientDirectionDown);
}
@end
