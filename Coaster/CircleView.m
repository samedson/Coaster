//
//  CircleView.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CircleView.h"

@interface CircleView()

@end

@implementation CircleView

- (id)initWithCenter:(CGPoint)center
              radius:(CGFloat)radius
{
  CGRect frame = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);

  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }

  self.layer.cornerRadius = radius;
  self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
  self.yOriginal = frame.origin.y;
  [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
  
  return self;
}

- (void)handleTap {
  self.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:1 alpha:1];
  [UIView animateWithDuration:3 animations:^(void){
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
  }];
}

@end
