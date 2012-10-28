//
//  CPColorMapOverlay.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 10/25/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPColorMapOverlay.h"

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
        // Background Color needs to be in this Layer
        self.backgroundColor =  [UIColor clearColor];
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
    
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    
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
                       [[UIColor colorWithHue:(270/360.0) saturation:1 brightness:kCPBrightness alpha:1.0] CGColor],
                       [[UIColor colorWithHue:(0/360.0) saturation:0 brightness:kCPBrightness alpha:0] CGColor],
                       CPGradientDirectionRight);
    
    drawLinearGradient(ctx,
                       bottomSide,
                       [[UIColor colorWithHue:(180/360.0) saturation:1 brightness:kCPBrightness alpha:1.0] CGColor],
                       [[UIColor colorWithHue:(270/360.0) saturation:0 brightness:kCPBrightness alpha:0] CGColor],
                       CPGradientDirectionUp);
    
    drawLinearGradient(ctx,
                       rightSide,
                       [[UIColor colorWithHue:(90/360.0) saturation:1 brightness:kCPBrightness alpha:1.0] CGColor],
                       [[UIColor colorWithHue:(180/360.0) saturation:0 brightness:kCPBrightness alpha:0] CGColor],
                       CPGradientDirectionLeft);
    
    drawLinearGradient(ctx,
                       topSide,
                       [[UIColor colorWithHue:(0/360.0) saturation:1 brightness:kCPBrightness alpha:1.0] CGColor],
                       [[UIColor colorWithHue:(90/360.0) saturation:0 brightness:kCPBrightness alpha:0] CGColor],
                       CPGradientDirectionDown);
}
@end
