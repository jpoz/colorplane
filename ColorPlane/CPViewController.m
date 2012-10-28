//
//  CPViewController.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/3/12.
//  Copyright (c) 2012 Notion HQ. All rights reserved.
//

#import "CPViewController.h"
#import "CPTargetView.h"
#import "CPMovementManager.h"
#import "CPColorMapOverlay.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>

@interface CPViewController () <CPMovementManagerDelegate>

@property (nonatomic, retain) CPTargetView *targetView;
@property (nonatomic, retain) CPColorMapOverlay *colorMapOverlayView;

@end

@implementation CPViewController

@synthesize dataLabel = _dataLabel;
@synthesize targetView = _targetView;
@synthesize colorMapOverlayView = _colorMapOverlayView;

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    
    CPColorMapOverlay *colorMap = [[CPColorMapOverlay alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:colorMap];
    self.colorMapOverlayView = colorMap;
    
    CPTargetView *targetView = [[[CPTargetView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:targetView];
    self.targetView = targetView;
    
    [self changeColors];
    
    [[CPMovementManager manager] setDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self changeColors];
}

- (void)changeColors {
    int hue2 = (arc4random() % 360);
    float sat2 = (arc4random() % 70)/100.0;
    
    NSLog(@"Target %d° %0.2f", hue2, sat2);
    self.targetView.targetColor =  [UIColor colorWithHue:(hue2/360.0) saturation:sat2 brightness:kCPBrightness alpha:1.0];
    
    int hue1   = (arc4random() % 360);
    float sat1 = (arc4random() % 70)/100.0;
    
    NSLog(@"Background %d° %0.2f", hue1, sat1);
    self.colorMapOverlayView.backgroundColor =  [UIColor colorWithHue:(hue1/360.0) saturation:sat1 brightness:kCPBrightness alpha:1.0];
}


#pragma mark - Timer Control

- (IBAction)start:(id)sender {
    
    [self.targetView startTimer:sender];
}

- (IBAction)reset:(id)sender {
    
    [self.targetView resetTimer:sender];
}

- (IBAction)stop:(id)sender {
    
    [self.targetView stopTimer:sender];
}

#pragma mark - CPMovementManagerDelegate

- (IBAction)resetReferenceFrame:(id)sender {
    
    [[CPMovementManager manager] reset];
}

- (void)movementManager:(CPMovementManager*)manager gotAttitude:(CMAttitude*)attitude {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataLabel.text = [NSString stringWithFormat:@"Roll:%0.2f\nYaw:%0.2f\nPitch:%0.2f", attitude.roll, attitude.yaw, attitude.pitch];
    });
}

- (void)movementManager:(CPMovementManager*)manager arrivedAtColor:(UIColor*)color {    
    dispatch_async(dispatch_get_main_queue(), ^{
        double duration = (1.0/(5.0*kCPRefreshRatePerSecond));
        [UIView animateWithDuration:duration
                         animations:^{
                             self.view.layer.backgroundColor = color.CGColor;
                         }];    
    });
}

@end
