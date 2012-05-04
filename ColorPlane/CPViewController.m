//
//  CPViewController.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/3/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "CPViewController.h"

@interface CPViewController ()

@property (nonatomic, retain) CMMotionManager *manager;
@property (nonatomic, retain) NSOperationQueue *accelerometerQueue;
@property (nonatomic, retain) UIColor *color;

@end

@implementation CPViewController

@synthesize redLabel = _redLabel;
@synthesize blueLabel = _blueLabel;
@synthesize greenLabel = _greenLabel;

@synthesize manager = _manager;
@synthesize accelerometerQueue = _accelerometerQueue;
@synthesize color = _color;

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

- (void)viewDidLoad {
    [super viewDidLoad];    

    self.manager = [[[CMMotionManager alloc] init] autorelease];
    self.accelerometerQueue = [[NSOperationQueue alloc] init];
    [self.manager setAccelerometerUpdateInterval:(1.0/60.0)];
    [self.manager startAccelerometerUpdatesToQueue:self.accelerometerQueue
                                       withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {                                           
                                           if(error) {
                                               NSLog(@"Error: %@ User Info: %@", error.localizedDescription, error.userInfo);
                                           } else {
                                               
                                               NSLog(@"Accelerometer Data: %@", accelerometerData);
                                               [self setColor:[UIColor colorWithRed:(colorValueForComponent(accelerometerData.acceleration.x)/255.0)
                                                                              green:(colorValueForComponent(accelerometerData.acceleration.y)/255.0)
                                                                               blue:(colorValueForComponent(accelerometerData.acceleration.z)/255.0) 
                                                                              alpha:1.0]];
                                           }
                                       }];
}

- (void)setColor:(UIColor *)color {
    
    [_color release];
    _color = [color retain];
    
    NSLog(@"Color set to: %@", color);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = _color;
        CGFloat components[3];
        [self getRGBComponents:components forColor:_color];
        self.redLabel.text = [NSString stringWithFormat:@"Red %@", colorStringForValue(components[0]*255.0)];
        self.greenLabel.text = [NSString stringWithFormat:@"Green %@", colorStringForValue(components[1]*255.0)];
        self.blueLabel.text = [NSString stringWithFormat:@"Blue %@", colorStringForValue(components[2]*255.0)];
    });
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
