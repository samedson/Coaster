//
//  CircleView.h
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrailView.h"

#import "User.h"

// -----------------------------------------------------------------------------

enum CircleViewTrailMode {
  CircleViewTrailModeLeft = 1,
  CircleViewTrailModeBottomLeft = 2,
  CircleViewTrailModeBottom = 3,
  CircleViewTrailModeBottomRight = 4,
  CircleViewTrailModeRight = 5,
};

enum CircleViewNotifierType {
  CircleViewNotifierTypeNone = 1,
  CircleViewNotifierTypeTap = 2,
};

// -----------------------------------------------------------------------------

@interface CircleView : UIButton

- (id)initWithCenter:(CGPoint)center
              radius:(CGFloat)radius
              parent:(TrailView *)parent;

// When a circle gets reused.
- (void)didGetReused:(bool)leftToRight;

// Setting a new user
- (void)setUserForCurrentIndex;

// For like fading and stuff
- (void)drawCircleForYScreen:(CGFloat)yScreen;

// Exposing the tap target for ExtraScrollView tapping
- (void)handleTap;

@property (assign) CGFloat yOriginal;
@property (assign) NSInteger index;
@property (assign) enum CircleViewTrailMode circleViewTrailMode;

@end
