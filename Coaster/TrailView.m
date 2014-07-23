//
//  TrailView.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TrailView.h"

#import "CenterView.h"
#import "CircleView.h"

#import "CGUtil.h"

#define printlog if (false)

// Cells
static const CGFloat kCellRadius = 24;
static const CGFloat kLeftOffset = -92;
static const CGFloat kRightOffset = 800;
static const NSInteger kCellsPerPage = 26;
static const NSInteger kNumberOfCells = kCellsPerPage + 2;
static const NSInteger kPageSize = (2 * kCellRadius * kNumberOfCells - 3);
static const NSInteger kContentSize = 5000 * kPageSize;

// Deciding which mode
static const NSInteger kModeCutoffLeft_RightY = 0;
static const NSInteger kModeCutoffBottomLeft_LeftY = 570;
static const NSInteger kModeCutoffBottomLeft_BottomX = 20;
static const NSInteger kModeCutoffBottomRight_BottomX = 232;
static const NSInteger kModeCutoffBottomRight_RightY = 840;
static const NSInteger kModeCutoffRight_LeftY = 1400;

// ScrollView Properties
static const CGFloat kScrollViewDecelerationRate = 0.8;

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
    self.scrollView.decelerationRate = kScrollViewDecelerationRate;
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
    self.bottomScrollView.decelerationRate = kScrollViewDecelerationRate;
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
    self.rightScrollView.decelerationRate = kScrollViewDecelerationRate;
    self.rightScrollView.contentSize = CGSizeMake(2 * kCellRadius,
                                                  kContentSize + frame.size.height);
  }
  
  CGRect centerFrame = CGRectMake(2 * kCellRadius,
                                  0,
                                  frame.size.width - 4 * kCellRadius,
                                  frame.size.height - 2 * kCellRadius);
  UIView *centerView = [[CenterView alloc] initWithFrame:centerFrame];

  for (int i = 0; i < number; i++) {
    CGPoint center = CGPointMake(kCellRadius, (2 * kCellRadius) * i + kCellRadius - kLeftOffset);
    CircleView *circleView = [[CircleView alloc] initWithCenter:center
                                                         radius:kCellRadius];
    [self.circleViews addObject:circleView];
    [self.scrollView addSubview:circleView];
  }

  [self addSubview:self.scrollView];
  [self addSubview:self.rightScrollView];
  [self addSubview:self.bottomScrollView];
  [self addSubview:centerView];
  
  self.ctrlScrollView = self.scrollView;
  self.ctrlScrollView.contentOffset = CGPointMake(0, 300);
  [self setCircleViewTrailModes];
  [self scrollViewDidScroll:self.scrollView];
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

- (bool)classifyCircleAt:(int)index
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
      } else if (yScreen > kModeCutoffBottomRight_RightY) { // High bottom right -+ right
        circle.circleViewTrailMode = CircleViewTrailModeRight;
      }
      break;
    case CircleViewTrailModeRight:
      if (yScreen < kModeCutoffBottomRight_RightY) { // Low right -> bottom right
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
    printlog NSLog(@"%i -> %i", prevMode, circle.circleViewTrailMode);
    return true;
  } else {
    return false;
  }
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

  switch (circle.circleViewTrailMode) {
    case CircleViewTrailModeLeft:
      circle.frame = CGRectMove(circleFrame,
                                0,
                                yCircle + kLeftOffset);
//      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
      break;
    case CircleViewTrailModeBottomLeft:
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                yCircle + kLeftOffset);
//      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5];
      break;
    case CircleViewTrailModeBottom:
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                yMax + yScroll);
//      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
      break;
    case CircleViewTrailModeBottomRight:
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
//      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.5];
      break;
    case CircleViewTrailModeRight:
      circle.frame = CGRectMove(circleFrame,
                                xRight,
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
//      circle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
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
    CGFloat speed = [self getScrollSpeed];
    CGFloat yScroll = scrollView.contentOffset.y;
    CircleView *previous = self.circleViews.lastObject;
    CircleView *current;
    for (int i = 0; i < kNumberOfCells; i++) {
      current = self.circleViews[i];
      bool changed = [self classifyCircleAt:i
                                    yScroll:yScroll
                             previousCircle:previous];
      [self positionCircle:current
                   atIndex:i
                   yScroll:yScroll
                     speed:speed
            previousCircle:previous];
      if (changed) {
        if ([self classifyCircleAt:i
                           yScroll:yScroll
                    previousCircle:previous]) {
          [self positionCircle:current
                       atIndex:i
                       yScroll:yScroll
                         speed:speed
                previousCircle:previous];
          if ([self classifyCircleAt:i
                             yScroll:yScroll
                      previousCircle:previous]) {
            [self positionCircle:current
                         atIndex:i
                         yScroll:yScroll
                           speed:speed
                  previousCircle:previous];
          }
        }
      }
      previous = current;
    }
    printlog NSLog(@"speed: %f", speed);
  }
  [self synchronizeScrollViews];
}

@end
