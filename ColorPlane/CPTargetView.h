//
//  CPTargetView.h
//  ColorPlane
//
//  Created by Collin Ruffenach on 5/12/12.
//  Copyright (c) 2012 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTargetView : UIView

- (void)setTargetColor:(UIColor*)targetColor;
- (UIColor*)targetColor;

@end