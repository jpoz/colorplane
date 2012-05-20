//
//  CPViewController.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/3/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPViewController.h"
#import "CPTargetView.h"
#import "CPMovementManager.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>

@interface CPViewController () <CPMovementManagerDelegate>

@property (nonatomic, retain) CPTargetView *targetView;

@end

@implementation CPViewController

@synthesize targetView = _targetView;

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    
    CPTargetView *targetView = [[[CPTargetView alloc] initWithFrame:CGRectMake(0, 
                                                                               0, 
                                                                               320, 
                                                                               136)] autorelease];
    
    [targetView setTargetColor:[UIColor randomColor]];
    [self.view addSubview:targetView];
    self.targetView = targetView;
    
    [[CPMovementManager manager] setDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark - Axis Limits Helper

- (IBAction)reset:(id)sender {
    
    [[CPMovementManager manager] resetAxisLimits];
}

#pragma mark - New Color Creation

- (IBAction)newColor:(id)sender {
    
    [self.targetView setTargetColor:[UIColor randomColor]];
}

#pragma mark - CPMovementManagerDelegate

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
