//
//  TrailView.h
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CenterView.h"

// -----------------------------------------------------------------------------

@class CornerButton;

// -----------------------------------------------------------------------------

@interface TrailView : UIView

@property (nonatomic, strong) CenterView *centerView;

- (void)reloadColors;

- (NSMutableArray *)getCircleViews;
- (CornerButton *)getLeftCornerButton;
- (CornerButton *)getRightCornerButton;

@end
