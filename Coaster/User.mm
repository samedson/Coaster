//
//  User.m
//  Coaster
//
//  Created by Samuel Edson on 7/25/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "User.h"

#import "UIColor+Stylesheet.h"

// -----------------------------------------------------------------------------

@interface User()

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;

@end

// -----------------------------------------------------------------------------

@implementation User

- (id)initWithUserImage:(UIImage *)image {
  self = [super init];
  if ( ! self) { return nil; }

  self.userImage = image;
  self.name = @"Some Name";
  self.color = [UIColor randomColor];
    
  return self;
}

#pragma mark - Description

- (NSString *)description {
  return [NSString stringWithFormat:@"User { name: %@,\ncolor: %@ }", self.name, self.color];;
}

#pragma mark - Info

- (bool)hasUserImage {
  return self.userImage != nil;
}

- (UIImage *)getUserImage {
  return self.userImage;
}

- (UIColor *)getColor {
  return self.color;
}

- (void)setColorForUser:(UIColor *)color {
  self.color = color;
}

@end
