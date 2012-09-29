//
//  CPAppDelegate.h
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/3/12.
//  Copyright (c) 2012 Notion HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPViewController;

@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CPViewController *viewController;

@end
