//
//  CPMovementManager.h
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/13/12.
//  Copyright (c) 2012 Notion HQ. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>

@protocol CPMovementManagerDelegate;

@interface CPMovementManager : NSObject

+ (id)manager;

@property (nonatomic, assign) id <CPMovementManagerDelegate> delegate;

- (void)resetAxisLimits;
- (void)reset;

@end

@protocol CPMovementManagerDelegate <NSObject>

@required

- (void)movementManager:(CPMovementManager*)manager gotAttitude:(CMAttitude*)attitude;
- (void)movementManager:(CPMovementManager*)manager arrivedAtColor:(UIColor*)color;

@end