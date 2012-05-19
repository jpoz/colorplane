//
//  CPMovementManager.h
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/13/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CPMovementManagerDelegate;

@interface CPMovementManager : NSObject

+ (id)manager;

@property (nonatomic, assign) id <CPMovementManagerDelegate> delegate;

- (void)resetAxisLimits;

@end

@protocol CPMovementManagerDelegate <NSObject>

@required

- (void)movementManager:(CPMovementManager*)manager arrivedAtColor:(UIColor*)color;

@end