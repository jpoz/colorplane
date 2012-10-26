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

@end

@implementation CPViewController

@synthesize dataLabel = _dataLabel;
@synthesize targetView = _targetView;

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    
    CPTargetView *targetView = [[[CPTargetView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:targetView];
    self.targetView = targetView;
    
    CPColorMapOverlay *colorMap = [[CPColorMapOverlay alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:colorMap];
    
    [[CPMovementManager manager] setDelegate:self];
    
    self.view.backgroundColor = [UIColor colorWithHue:(120.0/365.0)
                                           saturation:1.0
                                           brightness:0.8
                                                alpha:1.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
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
