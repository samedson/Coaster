//
//  TrailView.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TrailView.h"

#import "CircleView.h"

#import "CGUtil.h"

static const CGFloat kCellRadius = 24;
static const CGFloat kLeftOffset = -92;
static const CGFloat kRightOffset = 800;
static const NSInteger kCellsPerPage = 26;
static const NSInteger kNumberOfCells = kCellsPerPage + 2;
static const NSInteger kPageSize = (2 * kCellRadius * kNumberOfCells - 3);
static const NSInteger kContentSize = 500 * kPageSize;

// Deciding which mode
static const NSInteger kModeCutoffLeft_RightY = 0;
static const NSInteger kModeCutoffBottomLeft_LeftY = 570;
static const NSInteger kModeCutoffBottomLeft_BottomX = 20;
static const NSInteger kModeCutoffBottomRight_BottomX = 240;
static const NSInteger kModeCutoffBottomRight_Right = 820;
static const NSInteger kModeCutoffRight_LeftY = 1400;

@interface TrailView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *circleViews;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIScrollView *rightScrollView;
@property (nonatomic, strong) UIScrollView *ctrlScrollView;

@property (assign) CGFloat scrollSpeed;

@end

@implementation TrailView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }

  NSInteger number = kNumberOfCells;
  
  self.scrollSpeed = 0.0;
  
  self.circleViews = [[NSMutableArray alloc] init];
  
  {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectOffset(frame, 0, 24)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.contentSize = CGSizeMake(2 * kCellRadius,
                                             kContentSize + frame.size.height);
  }
  
  {
    CGRect bottomFrame = CGRectMake(0,
                                    frame.size.height - 2 * kCellRadius,
                                    frame.size.width,
                                    2 * kCellRadius);
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:bottomFrame];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.showsHorizontalScrollIndicator = false;
    self.bottomScrollView.contentSize = CGSizeMake(kContentSize + frame.size.width,
                                                   2 * kCellRadius);
  }
  
  {
    CGRect rightFrame = CGRectMake(frame.size.width - 2 * kCellRadius,
                                   0,
                                   2 * kCellRadius,
                                   frame.size.height);
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:rightFrame];
    self.rightScrollView.delegate = self;
    self.rightScrollView.showsVerticalScrollIndicator = false;
    self.rightScrollView.contentSize = CGSizeMake(2 * kCellRadius,
                                                  kContentSize + frame.size.height);
  }
  
  CGRect centerFrame = CGRectMake(2 * kCellRadius,
                                  0,
                                  frame.size.width - 4 * kCellRadius,
                                  frame.size.height - 2 * kCellRadius);
  UIView *centerView = [[UIView alloc] initWithFrame:centerFrame];
  centerView.backgroundColor = [UIColor whiteColor];

  for (int i = 0; i < number; i++) {
    CGPoint center = CGPointMake(kCellRadius, (2 * kCellRadius) * i + kCellRadius - kLeftOffset);
    CircleView *circleView = [[CircleView alloc] initWithCenter:center
                                                         radius:kCellRadius];
    [self.circleViews addObject:circleView];
    [self.scrollView addSubview:circleView];
  }

  [self addSubview:centerView];
  [self addSubview:self.scrollView];
  [self addSubview:self.rightScrollView];
  [self addSubview:self.bottomScrollView];
  
  [self setCircleViewTrailModes];
  self.ctrlScrollView = self.scrollView;
  [self scrollViewDidScroll:self.scrollView];
  
  return self;
}

#pragma mark - ScrollView Helper

// Should be called on init
- (void)setCircleViewTrailModes {
  for (int i = 0; i < kNumberOfCells; i++) {
    if (i <= 9) {
      ((CircleView *)self.circleViews[i]).circleViewTrailMode = CircleViewTrailModeLeft;
    } else if (i == 10) {
      ((CircleView *)self.circleViews[i]).circleViewTrailMode = CircleViewTrailModeBottomLeft;
    } else if (i <= 14) {
      ((CircleView *)self.circleViews[i]).circleViewTrailMode = CircleViewTrailModeBottom;
    } else if (i == 15) {
      ((CircleView *)self.circleViews[i]).circleViewTrailMode = CircleViewTrailModeBottomRight;
    } else {
      ((CircleView *)self.circleViews[i]).circleViewTrailMode = CircleViewTrailModeRight;
    }
  }
}

- (void)synchronizeScrollViews {
  if (self.scrollView == self.ctrlScrollView) {
    self.bottomScrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.y, 0);
    self.rightScrollView.contentOffset = CGPointMake(0, kContentSize - self.scrollView.contentOffset.y);
    
  } else if (self.bottomScrollView == self.ctrlScrollView) {
    self.scrollView.contentOffset = CGPointMake(0, self.bottomScrollView.contentOffset.x);
    self.rightScrollView.contentOffset = CGPointMake(0, kContentSize - self.bottomScrollView.contentOffset.x);
    
  } else if (self.rightScrollView == self.ctrlScrollView) {
    self.scrollView.contentOffset = CGPointMake(0, kContentSize - self.rightScrollView.contentOffset.y);
    self.bottomScrollView.contentOffset = CGPointMake(kContentSize - self.rightScrollView.contentOffset.y, 0);
  }
  
  if (false) {
    NSLog(@"R: %f", self.rightScrollView.contentOffset.y);
    NSLog(@"B: %f", self.bottomScrollView.contentOffset.x);
    NSLog(@"L: %f", self.scrollView.contentOffset.y);
    NSLog(@"-------");
  }
}

- (CGFloat)getScrollSpeed {
  static double prevCallTime = 0;
  static double prevCallOffset = 0;
  double curCallTime = CACurrentMediaTime();
  double timeDelta = curCallTime - prevCallTime;
  double curCallOffset = self.scrollView.contentOffset.y;
  double offsetDelta = curCallOffset - prevCallOffset;
  double velocity = offsetDelta / timeDelta;
  prevCallTime = curCallTime;
  prevCallOffset = curCallOffset;
  return velocity;
}

- (int)getNextIndex:(int)current {
  if (current == self.circleViews.count - 1) {
    return 0;
  } else {
    return current + 1;
  }
}

- (CircleView *)classifyCircleAt:(int)index
                         yScroll:(CGFloat)yScroll
                  previousCircle:(CircleView *)prevCircle {
  CircleView *circle = self.circleViews[index];
  CGRect circleFrame = circle.frame;
  CGFloat yCircle = circle.yOriginal;
  CGFloat xCurrent = circleFrame.origin.x;
  CGFloat yScreen = yCircle - yScroll;
  
  enum CircleViewTrailMode prevMode = circle.circleViewTrailMode;
  
  switch (circle.circleViewTrailMode) {
    case CircleViewTrailModeLeft:
      if (yScreen < kModeCutoffLeft_RightY) { // High left -> right
        circle.circleViewTrailMode = CircleViewTrailModeRight;
        circle.yOriginal += kPageSize; // Change Page Size
      } else if (yScreen > kModeCutoffBottomLeft_LeftY) { // Low left -+ bottom left
        circle.circleViewTrailMode = CircleViewTrailModeBottomLeft;
      }
      break;
    case CircleViewTrailModeBottomLeft:
      if (yScreen < kModeCutoffBottomLeft_LeftY) { // High bottom left -> left
        circle.circleViewTrailMode = CircleViewTrailModeLeft;
      } else if (xCurrent > kModeCutoffBottomLeft_BottomX) { // Right bottom left -+ bottom
        circle.circleViewTrailMode = CircleViewTrailModeBottom;
      }
      break;
    case CircleViewTrailModeBottom:
      if (xCurrent < kModeCutoffBottomLeft_BottomX) { // Left bottom -> bottom left
        circle.circleViewTrailMode = CircleViewTrailModeBottomLeft;
      } else if (xCurrent > kModeCutoffBottomRight_BottomX) { // Right bottom -> bottom right
        circle.circleViewTrailMode = CircleViewTrailModeBottomRight;
      }
      break;
    case CircleViewTrailModeBottomRight:
      if (xCurrent < kModeCutoffBottomRight_BottomX) { // Left bottom right -> bottom
        circle.circleViewTrailMode = CircleViewTrailModeBottom;
      } else if (yScreen > kModeCutoffBottomRight_Right) { // High bottom right -+ right
        circle.circleViewTrailMode = CircleViewTrailModeRight;
      } else if (xCurrent > 2 * kCellRadius) {
        circle.circleViewTrailMode = CircleViewTrailModeRight;
      }
      break;
    case CircleViewTrailModeRight:
      if (yScreen < kModeCutoffBottomRight_Right) { // Low right -> bottom right
        circle.circleViewTrailMode = CircleViewTrailModeBottomRight;
      } else if (yScreen > kModeCutoffRight_LeftY) { // High right -> left
        circle.circleViewTrailMode = CircleViewTrailModeLeft;
        circle.yOriginal -= kPageSize; // Change Page Size
      }
      break;
    default:
      break;
  }
  if (prevMode != circle.circleViewTrailMode) {
    NSLog(@"%i -> %i", prevMode, circle.circleViewTrailMode);
  }
  return circle;
}

- (void)positionCircle:(CircleView *)circle
               atIndex:(int)index
               yScroll:(CGFloat)yScroll
                 speed:(CGFloat)speed
        previousCircle:(CircleView *)prevCircle {
  CGRect circleFrame = circle.frame;
  CGFloat yCircle = circle.yOriginal;
  CGFloat yMax = self.frame.size.height - 3 * kCellRadius;
  CGFloat xRight = self.frame.size.width - 2 * kCellRadius;
  
  int nextIndex = [self getNextIndex:index];
  CGPoint nextOrigin = ((CircleView *)self.circleViews[nextIndex]).frame.origin;
  CGPoint prevOrigin = prevCircle.frame.origin;

  switch (circle.circleViewTrailMode) {
    case CircleViewTrailModeLeft:
      circle.frame = CGRectMove(circleFrame,
                                0,
                                yCircle + kLeftOffset);
      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
      break;
    case CircleViewTrailModeBottomLeft:
      circle.frame = CGRectMove(circleFrame,
                                nextOrigin.x - 2 * kCellRadius,
                                yCircle + kLeftOffset);
      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5];
      break;
    case CircleViewTrailModeBottom:
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                yMax + yScroll);
      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
      break;
    case CircleViewTrailModeBottomRight:
      circle.frame = CGRectMove(circleFrame,
                                prevOrigin.x + 2 * kCellRadius,
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.5];
      break;
    case CircleViewTrailModeRight:
      circle.frame = CGRectMove(circleFrame,
                                xRight,
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
      circle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
      break;
    default:
      break;
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  self.ctrlScrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == self.scrollView) {
    CGFloat yScroll = scrollView.contentOffset.y;
    CGFloat speed = [self getScrollSpeed];
    CircleView *previous = self.circleViews.lastObject;
    CircleView *current;
    for (int i = 0; i < kNumberOfCells; i++) {
      current = [self classifyCircleAt:i
                                yScroll:yScroll
                         previousCircle:previous];
      [self positionCircle:current
                   atIndex:i
                   yScroll:yScroll
                     speed:speed
            previousCircle:previous];
      previous = current;
    }
  }
  [self synchronizeScrollViews];
}


  //    for (CircleView *circle in self.circleViews) {
  //      CGFloat yCircle = circle.yOriginal;
  //      if (speed < 0.0) {
  //        if (yCircle - yScroll < 20) {
  //          circle.yOriginal += kPageSize;
  //          //        NSLog(@"b");
  //          circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
  //        }
  //      } else if (speed > 0.0) {
  //        if (yCircle - yScroll > 1350) {
  //          circle.yOriginal -= kPageSize;
  //          circle.frame = CGRectMake(-10,
  //                                    0,
  //                                    2 * kCellRadius,
  //                                    2 * kCellRadius);
  //          circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
  //          //        NSLog(@"a");
  //        }
  //      } else {
  //        circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.3];
  //      }
  //
  //
  //      if ((yCircle - yScroll) >= yMax) { // Bottom
  //        circle.frame = CGRectMake(-1 * yScroll + (yCircle - self.frame.size.height),
  //                                  yMax + yScroll,
  //                                  2 * kCellRadius,
  //                                  2 * kCellRadius);
  //      }
  //      if (circle.frame.origin.x <= 0) { // Left
  //        circle.frame = CGRectMake(0,
  //                                  yCircle + kLeftOffset,
  //                                  2 * kCellRadius,
  //                                  2 * kCellRadius);
  //      }
  //      if (circle.frame.origin.x >= xRight) { // Right
  //        circle.frame = CGRectMake(xRight,
  //                                  2 * yScroll + (yMax - yCircle) + rightOffset,
  //                                  2 * kCellRadius,
  //                                  2 * kCellRadius);
  //      }
  ////      NSLog(@"s: %f", yCircle - yScroll);
  ////      NSLog(@"c: %f", yCircle);
  ////      NSLog(@"m: %f", yMax);
  //      NSLog(@"x:%f, y:%f", circle.frame.origin.x, circle.frame.origin.y);
  //    }
  //  } else if (scrollView == self.bottomScrollView) {
  ////    CGFloat offset = scrollView.contentOffset.x;
  ////    if (offset < 0) {
  ////      scrollView.contentOffset = CGPointMake(0, kContentSize);
  ////    } else if (offset > kContentSize) {
  ////      scrollView.contentOffset = CGPointMake(0, 0);
  ////    }
  ////  } else if (scrollView == self.rightScrollView) {
  ////    CGFloat offset = scrollView.contentOffset.y;
  ////    if (offset < 0) {
  ////      scrollView.contentOffset = CGPointMake(0, kContentSize);
  ////    } else if (offset > kContentSize) {
  ////      scrollView.contentOffset = CGPointMake(0, 0);
  ////    }
  //  NSLog(@"-------------------");

  
//      CGFloat xCircleNew = circle.frame.origin.x;
//      CGFloat yCircleNew = circle.frame.origin.y;
//      CGFloat absY = yCircleNew - yScroll;
//      if (xCircleNew <= 30 && absY >= 440) { // Lower Left
//        CGFloat newX = yScroll + (yMax - yCircle) + 70;
//        CGFloat newY = 2 * yScroll + (yMax - yCircle) + 500;
//        circle.frame = CGRectMake(newX,
//                                  newY,
//                                  2 * kCellRadius,
//                                  2 * kCellRadius);
//        NSLog(@"x: %f", newX);
//        NSLog(@"y: %f", newY);
//        circle.backgroundColor = [UIColor redColor];
//      } else if (xCircleNew >= 252 && absY >= 450) { // Lower Right
//        circle.frame = CGRectMake(xRight - (yScroll + (yMax - yCircle) + rightOffset - 455),
//                                  2 * yScroll + (yMax - yCircle) + rightOffset,
//                                  2 * kCellRadius,
//                                  2 * kCellRadius);
//        circle.backgroundColor = [UIColor blueColor];
//      } else {
//        circle.backgroundColor = [UIColor blackColor];
//      }


@end
