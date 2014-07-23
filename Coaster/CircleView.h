//
//  CircleView.h
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CircleViewTrailMode {
  CircleViewTrailModeLeft = 1,
  CircleViewTrailModeBottomLeft = 2,
  CircleViewTrailModeBottom = 3,
  CircleViewTrailModeBottomRight = 4,
  CircleViewTrailModeRight = 5,
};

@interface CircleView : UIView

- (id)initWithCenter:(CGPoint)center
              radius:(CGFloat)radius;

@property (assign) CGFloat yOriginal;
@property (assign) enum CircleViewTrailMode circleViewTrailMode;

@end
