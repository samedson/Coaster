//
//  CenterView.m
//  Coaster
//
//  Created by Samuel Edson on 7/22/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CenterView.h"

#import "CircleImageView.h"
#import "TrailView.h"

#import "UIColor+Stylesheet.h"

#import "Constants.h"

#import "UserList.h"

// -----------------------------------------------------------------------------

static const CGFloat kTop = 46 + kCellRadius;
static const CGFloat kCenterCornerRadius = kCellRadius + 1;

// -----------------------------------------------------------------------------

@interface CenterView()

@property (nonatomic, strong) CircleImageView *userImage;

@property (nonatomic, strong) UIView *topBar;

@end

// -----------------------------------------------------------------------------

@implementation CenterView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }
  
  self.backgroundColor = [UIColor whiteColor];
  self.layer.cornerRadius = kCenterCornerRadius;
  self.layer.borderColor = [[UIColor appleBlue] CGColor];
  self.layer.borderWidth = kBorderWidth;
  
  {
    CGRect topBarFrame = CGRectMake(0, kTop, self.frame.size.width, kCenterBarHeight);
    self.topBar = [[UIView alloc] initWithFrame:topBarFrame];
    self.topBar.backgroundColor = [UIColor appleBlue];
    
    [self addSubview:self.topBar];
  }
  
  self.userImage = [[CircleImageView alloc] initWithOrigin:CGPointMake(10, kTop + kCenterBarHeight + 10 - kBorderWidth)
                                                    radius:kCellRadius
                                                     image:nil];
  [self addSubview:self.userImage];
  
  return self;
}

- (void)reloadColors {
  UIColor *currentColor = globalUserList->getCurrentUserColor();
  self.layer.borderColor = [currentColor CGColor];
  self.topBar.backgroundColor = currentColor;
}

- (void)loadUser:(User *)user {
  NSLog(@"loadUser");
  [self.userImage setImage:[user getUserImage]];
}

@end
