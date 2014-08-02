//
//  CircleView.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CircleView.h"

#import "UIColor+Stylesheet.h"

#include "UserList.h"

#include "Constants.h"

// -----------------------------------------------------------------------------

//#define FADE_TOP

// -----------------------------------------------------------------------------

#ifdef FADE_TOP
static const CGFloat kFadeSpeed = 100;
static const CGFloat kFadeDistance = 150;
#endif

// -----------------------------------------------------------------------------

@interface CircleView()

@property (nonatomic, strong) TrailView *parent;
@property (nonatomic, strong) User *user;

@end

// -----------------------------------------------------------------------------

@implementation CircleView

- (id)initWithCenter:(CGPoint)center
              radius:(CGFloat)radius
              parent:(TrailView *)parent
{
  CGRect frame = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);

  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }

  self.parent = parent;
  
  {
    self.layer.cornerRadius = radius;
    self.clipsToBounds = true;
    self.layer.borderWidth = kBorderWidth;
    
    [self setImage:[self.user getUserImage] forState:UIControlStateNormal];
    
    self.yOriginal = frame.origin.y;
    
    [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
  }

  return self;
}

// -----------------------------------------------------------------------------
#pragma mark - User Interaction

- (void)handleTap {
//  self.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:1 alpha:1];
//  [UIView animateWithDuration:1.5 animations:^(void) {
//    self.backgroundColor = self.originalColor;
//  }];
  [self.parent.centerView loadUser:self.user];
  [self setViewNotifier:CircleViewNotifierTypeTap];
}

// -----------------------------------------------------------------------------
#pragma mark - TrailView Interaction

- (void)didGetReused:(bool)leftToRight {
  // Move yOriginal and change index for new user
  if (leftToRight) {
    self.yOriginal += kPageSize;
    self.index += kNumberOfCells;
  } else {
    self.yOriginal -= kPageSize;
    self.index -= kNumberOfCells;
  }
  
  [self setUserForCurrentIndex];
}


// -----------------------------------------------------------------------------
#pragma mark - User Handling

- (void)setUserForCurrentIndex {
  // Get new user
  self.user = globalUserList->getUserForIndex(self.index);
  
  [self loadUser];
}

- (void)loadUser {
  if ([self.user hasUserImage]) {
    [self setImage:[self.user getUserImage] forState:UIControlStateNormal];
  } else {
    [self setImage:nil forState:UIControlStateNormal];
  }
  
  // Clear ViewNotifier
  [self setViewNotifierNone];
}

// -----------------------------------------------------------------------------
#pragma mark - View Notifiers

- (void)setViewNotifier:(CircleViewNotifierType)type {
  if (type == CircleViewNotifierTypeTap) {
    self.layer.borderColor = [[self.user getColor] CGColor];
  }
}

- (void)setViewNotifierNone {
  self.layer.borderColor = [[UIColor clearColor] CGColor];
}

// -----------------------------------------------------------------------------
#pragma mark - View

- (void)drawCircleForYScreen:(CGFloat)yScreen {
#ifdef FADE_TOP
  if (yScreen < kModeCutoffLeft_RightY + 180.5) {
    self.alpha = (kFadeSpeed - ((kModeCutoffLeft_RightY + kFadeDistance + 30.5) - yScreen)) / kFadeSpeed;
  } else if (yScreen > kModeCutoffRight_LeftY - 150) {
    self.alpha = (kFadeSpeed - (yScreen - (kModeCutoffRight_LeftY - kFadeDistance))) / kFadeSpeed;
  } else {
    self.alpha = 1;
  }
#endif
}

@end
