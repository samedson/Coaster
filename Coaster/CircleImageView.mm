//
//  CircleImageView.m
//  Coaster
//
//  Created by Samuel Edson on 8/2/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

- (id)initWithOrigin:(CGPoint)origin
              radius:(CGFloat)radius
               image:(UIImage *)image
{
  CGRect frame = CGRectMake(origin.x, origin.y, 2 * radius, 2 * radius);
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }
  
  self.layer.cornerRadius = radius;
  self.clipsToBounds = true;
  [self setImage:image];
  
  return self;
}

- (void)setImage:(UIImage *)image {
  [self setImage:image forState:UIControlStateNormal];
}

@end
