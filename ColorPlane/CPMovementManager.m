//
//  CPMovementManager.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/13/12.
//  Copyright (c) 2012 Notion HQ. All rights reserved.
//

#import "CPMovementManager.h"
#import <CoreMotion/CoreMotion.h>

#define kAxisLimitRedKey @"X"
#define kAxisLimitGreenKey @"Y"
#define kAxisLimitBlueKey @"Z"

#define kAxisLimitMinKey @"MIN"
#define kAxisLimitMaxKey @"MAX"

@interface CPMovementManager () {

    float kCPRedChannelNormalMax;
    float kCPGreenChannelNormalMax;
    float kCPBlueChannelNormalMax;
}

#pragma mark - Private Properties

@property (nonatomic, retain) CMMotionManager *manager;
@property (nonatomic, retain) NSOperationQueue *accelerometerQueue;
@property (nonatomic, retain) NSMutableDictionary *axisLimits;

@end

#pragma mark - Constant Definition

@implementation CPMovementManager

#pragma mark - Synthesized Properties

@synthesize delegate = _delegate;

@synthesize manager = _manager;
@synthesize accelerometerQueue = _accelerometerQueue;
@synthesize axisLimits = _axisLimits;

#pragma mark - Helper Methods

float colorValueForComponent(float component) {    
    float offset = 127 * component;
    return 127.0 + offset;
}

NSString* colorStringForValue(float value) {    
    return [NSString stringWithFormat:@"%0.f", value];
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void)resetAxisLimits {
    
    NSMutableDictionary *blankMinMaxHolder1 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:
                                                                                  [NSNumber numberWithFloat:CGFLOAT_MAX],
                                                                                  [NSNumber numberWithFloat:CGFLOAT_MIN],
                                                                                  nil]
                                                                                 forKeys:[NSMutableArray arrayWithObjects:
                                                                                          kAxisLimitMinKey,
                                                                                          kAxisLimitMaxKey,
                                                                                          nil]];
    
    NSMutableDictionary *blankMinMaxHolder2 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:
                                                                                         [NSNumber numberWithFloat:CGFLOAT_MAX],
                                                                                         [NSNumber numberWithFloat:CGFLOAT_MIN],
                                                                                         nil]
                                                                                forKeys:[NSMutableArray arrayWithObjects:
                                                                                         kAxisLimitMinKey,
                                                                                         kAxisLimitMaxKey,
                                                                                         nil]];
    
    NSMutableDictionary *blankMinMaxHolder3 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:
                                                                                         [NSNumber numberWithFloat:CGFLOAT_MAX],
                                                                                         [NSNumber numberWithFloat:CGFLOAT_MIN],
                                                                                         nil]
                                                                                 forKeys:[NSMutableArray arrayWithObjects:
                                                                                          kAxisLimitMinKey,
                                                                                          kAxisLimitMaxKey,
                                                                                          nil]];
    
    NSMutableDictionary *axisLimits = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:
                                                                                  blankMinMaxHolder1,
                                                                                  blankMinMaxHolder2,
                                                                                  blankMinMaxHolder3,
                                                                                  nil]
                                                                         forKeys:[NSMutableArray arrayWithObjects:
                                                                                  kAxisLimitRedKey,
                                                                                  kAxisLimitGreenKey,
                                                                                  kAxisLimitBlueKey,
                                                                                  nil]];
    
    NSLog(@"Axis Limits Reset: %@", axisLimits);
    
    self.axisLimits = axisLimits;
}

- (void)recordAxisValuesForAccelerationData:(CMAccelerometerData*)data {
    
    CGFloat rMin = [[[_axisLimits objectForKey:kAxisLimitRedKey] objectForKey:kAxisLimitMinKey] floatValue];
    CGFloat rMax = [[[_axisLimits objectForKey:kAxisLimitRedKey] objectForKey:kAxisLimitMaxKey] floatValue];
    CGFloat gMin = [[[_axisLimits objectForKey:kAxisLimitGreenKey] objectForKey:kAxisLimitMinKey] floatValue];
    CGFloat gMax = [[[_axisLimits objectForKey:kAxisLimitGreenKey] objectForKey:kAxisLimitMaxKey] floatValue];
    CGFloat bMin = [[[_axisLimits objectForKey:kAxisLimitBlueKey] objectForKey:kAxisLimitMinKey] floatValue];
    CGFloat bMax = [[[_axisLimits objectForKey:kAxisLimitBlueKey] objectForKey:kAxisLimitMaxKey] floatValue];
    
    if(data.acceleration.x < rMin) {
        [[_axisLimits objectForKey:kAxisLimitRedKey] setObject:[NSNumber numberWithFloat:data.acceleration.x] forKey:kAxisLimitMinKey];
    } 
    if(data.acceleration.y > rMax) {
        [[_axisLimits objectForKey:kAxisLimitRedKey] setObject:[NSNumber numberWithFloat:data.acceleration.x] forKey:kAxisLimitMaxKey];
    }
    
    if(data.acceleration.y < gMin) {
        [[_axisLimits objectForKey:kAxisLimitGreenKey] setObject:[NSNumber numberWithFloat:data.acceleration.y] forKey:kAxisLimitMinKey];
    } 
    if(data.acceleration.y > gMax) {
        [[_axisLimits objectForKey:kAxisLimitGreenKey] setObject:[NSNumber numberWithFloat:data.acceleration.y] forKey:kAxisLimitMaxKey];
    }
    
    if(data.acceleration.z < bMin) {
        [[_axisLimits objectForKey:kAxisLimitBlueKey] setObject:[NSNumber numberWithFloat:data.acceleration.z] forKey:kAxisLimitMinKey];
    } 
    if(data.acceleration.z > bMax) {
        [[_axisLimits objectForKey:kAxisLimitBlueKey] setObject:[NSNumber numberWithFloat:data.acceleration.z] forKey:kAxisLimitMaxKey];
    }
    
    NSLog(@"R { %f , %f }, G { %f , %f }, B { %f , %f }", 
          [[[_axisLimits objectForKey:kAxisLimitRedKey] objectForKey:kAxisLimitMinKey] floatValue],
          [[[_axisLimits objectForKey:kAxisLimitRedKey] objectForKey:kAxisLimitMaxKey] floatValue],
          [[[_axisLimits objectForKey:kAxisLimitGreenKey] objectForKey:kAxisLimitMinKey] floatValue],
          [[[_axisLimits objectForKey:kAxisLimitGreenKey] objectForKey:kAxisLimitMaxKey] floatValue],
          [[[_axisLimits objectForKey:kAxisLimitBlueKey] objectForKey:kAxisLimitMinKey] floatValue],
          [[[_axisLimits objectForKey:kAxisLimitBlueKey] objectForKey:kAxisLimitMaxKey] floatValue]);
}

#pragma mark - Color Calculator

CGFloat restrictValueBetween(CGFloat value, CGFloat a, CGFloat b) {
    
    CGFloat val = value;
    val = MAX(a, val);
    val = MIN(b, val);
    
    return val;
}

- (NSArray*)colorChannelValuesForAccelerationData:(CMAccelerometerData*)data {
    
    CGFloat r = data.acceleration.x;
    CGFloat g = data.acceleration.y;
    CGFloat b = data.acceleration.z;
    
    r = ((r+fabsf(kCPRedChannelMin))/kCPRedChannelNormalMax);
    g = ((g+fabsf(kCPGreenChannelMin))/kCPGreenChannelNormalMax);
    b = ((b+fabsf(kCPBlueChannelMin))/kCPBlueChannelNormalMax);    
    
    r = restrictValueBetween(r, 0, 1);
    g = restrictValueBetween(g, 0, 1);
    b = restrictValueBetween(b, 0, 1);
    
    r = roundf(r*255.0);
    g = roundf(g*255.0);
    b = roundf(b*255.0);
    
    r = restrictValueBetween(r, 0, 255);
    g = restrictValueBetween(g, 0, 255);
    b = restrictValueBetween(b, 0, 255);
    
    NSInteger buckets = floorf((kCPColorChannelResolution*0.01)*255.0);
    
    r = floorf(((float)buckets/255.0)*r);
    g = floorf(((float)buckets/255.0)*g);
    b = floorf(((float)buckets/255.0)*b);
    
    CGFloat factor = 255.0/(float)buckets;
    
    r = roundf(factor*r);
    g = roundf(factor*g);
    b = roundf(factor*b);
    
    NSLog(@"R: %f G: %f B: %f", r, g, b);
    
    r = (r/255.0);
    g = (g/255.0);
    b = (b/255.0);
    
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:r],
            [NSNumber numberWithFloat:g], 
            [NSNumber numberWithFloat:b], nil];
}

- (UIColor*)colorForAccelerometerData:(CMAccelerometerData*)data {
    
    NSArray *colorChannelValues = [self colorChannelValuesForAccelerationData:data];
    
    return [UIColor colorWithRed:[[colorChannelValues objectAtIndex:0] floatValue]
                           green:[[colorChannelValues objectAtIndex:1] floatValue]
                            blue:[[colorChannelValues objectAtIndex:2] floatValue]
                           alpha:1.0];
}

#pragma mark - Singelton Accessor

+ (id)manager {
    static CPMovementManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Initializer

- (id)init {
    
    self = [super init];
    
    if(self) {
        
        kCPRedChannelNormalMax = fabsf(kCPRedChannelMin) + fabsf(kCPRedChannelMax);
        kCPGreenChannelNormalMax = fabsf(kCPGreenChannelMin) + fabsf(kCPGreenChannelMax);
        kCPBlueChannelNormalMax = fabsf(kCPBlueChannelMin) + fabsf(kCPBlueChannelMax);
        
        [self resetAxisLimits];
        
        self.manager = [[[CMMotionManager alloc] init] autorelease];
        self.accelerometerQueue = [[NSOperationQueue alloc] init];
        [self.manager setAccelerometerUpdateInterval:(1.0/kCPRefreshRatePerSecond)];
        [self.manager startAccelerometerUpdatesToQueue:self.accelerometerQueue
                                           withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {                                                             
                                               if(error) {                                                   
                                                   NSLog(@"Error from CPMotionManager: %@ User Info: %@", error.localizedDescription, error.userInfo);
                                               } else {   
                                                   [self.delegate movementManager:self arrivedAtColor:[self colorForAccelerometerData:accelerometerData]];
                                               }
                                           }];
    }
    
    return self;
}

@end
