//
//  CornerButton.m
//  Coaster
//
//  Created by Samuel Edson on 7/28/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CornerButton.h"

#import "UIColor+Stylesheet.h"

#import "Client.h"
#import "UserList.h"

// -----------------------------------------------------------------------------

@interface CornerButton()

@property (nonatomic, strong) TrailView *parent;

@property (assign) bool leftCorner;

@property (nonatomic, strong) UIColor *fillColor;

@end

// -----------------------------------------------------------------------------

@implementation CornerButton

- (id)initWithFrame:(CGRect)frame
       leftTriangle:(bool)leftTriangle
             parent:(TrailView *)parent
{
  self = [super initWithFrame:frame]; 
  if ( ! self) { return nil; }
  
  self.parent = parent;
  
  self.leftCorner = leftTriangle;
  [self addTarget:nil
           action:@selector(handleTap)
 forControlEvents:UIControlEventTouchUpInside];
  
  return self;
}

- (void)handleTap {
  if (self.leftCorner) {
    globalUserList->setCurrentUserColor([UIColor randomColor]);
    [self.parent reloadColors];
  } else {
    [globalClient getTest];
  }
}

- (void)setFillColorNew:(UIColor *)newFillColor {
  self.fillColor = newFillColor;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextBeginPath(ctx);
  if (self.leftCorner) {
    CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
  } else {                                                                   //    or
    CGContextMoveToPoint   (ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
  }
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // mid right
  CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
  CGContextClosePath(ctx);
  
  CGContextSetFillColorWithColor(ctx, [self.fillColor CGColor]);
  CGContextFillPath(ctx);
}

@end
