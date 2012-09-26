//
//  CPAppDelegate.m
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/3/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import "CPAppDelegate.h"

#import "CPViewController.h"

@implementation CPAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc {

    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[CPViewController alloc] initWithNibName:@"CPViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[CPViewController alloc] initWithNibName:@"CPViewController_iPad" bundle:nil] autorelease];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
