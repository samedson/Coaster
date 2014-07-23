//
//  CenterView.m
//  Coaster
//
//  Created by Samuel Edson on 7/22/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CenterView.h"

@implementation CenterView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }
  
//  self.backgroundColor = [UIColor lightGrayColor];
  self.layer.cornerRadius = 10;
  
  return self;
}
@end
