//
//  ExtraScrollView.m
//  Coaster
//
//  Created by Samuel Edson on 7/28/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ExtraScrollView.h"

#import "CircleView.h"
#import "CornerButton.h"

// -----------------------------------------------------------------------------

@interface ExtraScrollView()

@property (nonatomic, strong) TrailView *parent;

@end

// -----------------------------------------------------------------------------

@implementation ExtraScrollView

- (id)initWithFrame:(CGRect)frame
             parent:(TrailView *)parent
{
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }
  
  self.parent = parent;
  
  UITapGestureRecognizer *gestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleTap:)];
  [self addGestureRecognizer:gestureRecognizer];
  
  return self;
}

// Allows us to tap on circles and corners underneath the scrollview
- (void)handleTap:(UITapGestureRecognizer *)sender {
  NSMutableArray *circleViews = [self.parent getCircleViews];
  for (CircleView *circle in circleViews) {
    if (circle.circleViewTrailMode != CircleViewTrailModeLeft) {
      CGPoint location = [sender locationInView:circle];
      UIView *hitView = [circle hitTest:location withEvent:nil];
      if ([hitView isKindOfClass:[CircleView class]]) {
        [circle handleTap];
        return;
      }
    }
  }
  CornerButton *cornerButton = [self.parent getLeftCornerButton];
  CGPoint location = [sender locationInView:cornerButton];
  UIView *hitView = [cornerButton hitTest:location withEvent:nil];
  if ([hitView isKindOfClass:[CornerButton class]]) {
    [cornerButton handleTap];
    return;
  }
  cornerButton = [self.parent getRightCornerButton];
  location = [sender locationInView:cornerButton];
  hitView = [cornerButton hitTest:location withEvent:nil];
  if ([hitView isKindOfClass:[CornerButton class]]) {
    [cornerButton handleTap];
    return;
  }
}


@end
