//
//  TrailView.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TrailView.h"

#import "CircleView.h"

#import "CornerButton.h"
#import "ExtraScrollView.h"

#import "UIColor+Stylesheet.h"

#import "User.h"
#import "UserList.h"

#import "CGUtil.h"

#import "Constants.h"

// -----------------------------------------------------------------------------

#ifdef COASTER_DEBUG
#define printlog if (true)
#define printlog2 if (true)
#else
#define printlog if (false)
#define printlog2 if (false)
#endif

// -----------------------------------------------------------------------------

// Cell Positioning
static const CGFloat kLeftOffset = -109;
static const CGFloat kRightOffset = 806;
static const CGFloat kWeirdCircleSizeShift = kCellRadius - 20;
static const CGFloat kCellStartOffset = kContentSize / 2;

// ScrollView Properties
static const CGFloat kScrollViewDecelerationRate = UIScrollViewDecelerationRateFast;

// Corner Buttons
static const CGFloat kCornerButtonSize = 2 * kCellRadius - 7;

// -----------------------------------------------------------------------------

@interface TrailView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *circleViews;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ExtraScrollView *bottomScrollView;
@property (nonatomic, strong) ExtraScrollView *rightScrollView;
@property (nonatomic, strong) UIScrollView *ctrlScrollView;

@property (nonatomic, strong) CornerButton *leftCorner;
@property (nonatomic, strong) CornerButton *rightCorner;

@property (assign) CGFloat scrollSpeed;

@end

// -----------------------------------------------------------------------------

@implementation TrailView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if ( ! self) { return nil; }
  
  self.scrollSpeed = 0.0;
  
  self.circleViews = [[NSMutableArray alloc] init];
  
  {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectOffset(frame, 0, kCellRadius - kWeirdCircleSizeShift)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.decelerationRate = kScrollViewDecelerationRate;
    self.scrollView.canCancelContentTouches = false;
    self.scrollView.exclusiveTouch = false;
    self.scrollView.contentSize = CGSizeMake(2 * kCellRadius,
                                             kContentSize + frame.size.height);
  }
  
  {
    CGRect bottomFrame = CGRectMake(0,
                                    frame.size.height - 2 * kCellRadius,
                                    frame.size.width,
                                    2 * kCellRadius);
    self.bottomScrollView = [[ExtraScrollView alloc] initWithFrame:bottomFrame
                                                            parent:self];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.showsHorizontalScrollIndicator = false;
    self.bottomScrollView.decelerationRate = kScrollViewDecelerationRate;
    self.bottomScrollView.canCancelContentTouches = false;
    self.bottomScrollView.exclusiveTouch = false;
    self.bottomScrollView.contentSize = CGSizeMake(kContentSize + frame.size.width,
                                                   2 * kCellRadius);
#ifdef COASTER_DEBUG
    self.bottomScrollView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
#endif
  }
  
  {
    CGRect rightFrame = CGRectMake(frame.size.width - 2 * kCellRadius,
                                   0,
                                   2 * kCellRadius,
                                   frame.size.height);
    self.rightScrollView = [[ExtraScrollView alloc] initWithFrame:rightFrame
                                                           parent:self];
    self.rightScrollView.delegate = self;
    self.rightScrollView.showsVerticalScrollIndicator = false;
    self.rightScrollView.decelerationRate = kScrollViewDecelerationRate;
    self.rightScrollView.canCancelContentTouches = false;
    self.rightScrollView.exclusiveTouch = false;
    self.rightScrollView.contentSize = CGSizeMake(2 * kCellRadius,
                                                  kContentSize + frame.size.height);
#ifdef COASTER_DEBUG
    self.rightScrollView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
#endif
  }
  
  { // Center
    CGRect centerFrame = CGRectMake(2 * kCellRadius,
                                    -2 * kCellRadius,
                                    frame.size.width - 4 * kCellRadius,
                                    frame.size.height);
    self.centerView = [[CenterView alloc] initWithFrame:centerFrame];
  }

  for (int i = 0; i < kNumberOfCells; i++) {
    CGPoint center = CGPointMake(kCellRadius,
                                 (2 * kCellRadius) * i + kCellRadius - kLeftOffset + kCellStartOffset);
    CircleView *circleView = [[CircleView alloc] initWithCenter:center
                                                         radius:kCellRadius
                                                         parent:self];
    circleView.index = i;
    [self.circleViews addObject:circleView];
    [self.scrollView addSubview:circleView];
    
    [circleView didGetReused:true];
  }
  
  { // Corner Buttons
    CGRect leftCorner = CGRectMake(0,
                                   frame.size.height - kCornerButtonSize,
                                   kCornerButtonSize,
                                   kCornerButtonSize);
    self.leftCorner = [[CornerButton alloc] initWithFrame:leftCorner
                                             leftTriangle:true
                                                   parent:self];
    
    CGRect rightCorner = CGRectMake(frame.size.width - kCornerButtonSize,
                                    frame.size.height - kCornerButtonSize,
                                    kCornerButtonSize,
                                    kCornerButtonSize);
    self.rightCorner = [[CornerButton alloc] initWithFrame:rightCorner
                                              leftTriangle:false
                                                    parent:self];
  }

  [self addSubview:self.scrollView];
  [self addSubview:self.leftCorner];
  [self addSubview:self.rightCorner];
  [self addSubview:self.rightScrollView];
  [self addSubview:self.bottomScrollView];
  [self addSubview:self.centerView];
  
  self.ctrlScrollView = self.scrollView;
  self.ctrlScrollView.contentOffset = CGPointMake(0, kCellStartOffset + 300);
  [self setCircleViewTrailModes];
  [self scrollViewDidScroll:self.scrollView];
  [self scrollViewDidScroll:self.scrollView];
  [self scrollViewDidScroll:self.scrollView];
  [self scrollViewDidScroll:self.scrollView];
  [self scrollViewDidScroll:self.scrollView];

  [self reloadColors];
  
  return self;
}

// -----------------------------------------------------------------------------
#pragma mark - ReLayout

- (void)reloadColors {
  UIColor *currentColor = globalUserList->getCurrentUserColor();
  [self.leftCorner setFillColorNew:currentColor];
  [self.rightCorner setFillColorNew:currentColor];
  
  [self.centerView reloadColors];
}

// -----------------------------------------------------------------------------
#pragma mark - Informational

- (NSMutableArray *)getCircleViews {
  return self.circleViews;
}

- (CornerButton *)getLeftCornerButton {
  return self.leftCorner;
}

- (CornerButton *)getRightCornerButton {
  return self.rightCorner;
}

// -----------------------------------------------------------------------------
#pragma mark - ScrollView Helpers

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

#pragma mark - ScrollView Positioning

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
        [circle didGetReused:true];
      } else if (yScreen > kModeCutoffBottomLeft_LeftY) { // Low left -+ bottom left
        circle.circleViewTrailMode = CircleViewTrailModeBottomLeft;
      }
      break;
    case CircleViewTrailModeBottomLeft:
      if (yScreen < kModeCutoffBottomLeft_LeftY || // High bottom left -> left
          xCurrent < 0) {                          // Left bottom left -> left
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
        [circle didGetReused:false];
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
    case CircleViewTrailModeLeft: {
      circle.frame = CGRectMove(circleFrame,
                                0,
                                yCircle + kLeftOffset);
//      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
      break;
    }
    case CircleViewTrailModeBottomLeft: {
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                yCircle + kLeftOffset);
//      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5];
      break;
    }
    case CircleViewTrailModeBottom: {
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                yMax + yScroll + kWeirdCircleSizeShift);
      //      circle.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
      break;
    }
    case CircleViewTrailModeBottomRight: {
      circle.frame = CGRectMove(circleFrame,
                                -1 * yScroll + (yCircle - self.frame.size.height),
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
      //      circle.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.5];
      break;
    }
    case CircleViewTrailModeRight: {
      circle.frame = CGRectMove(circleFrame,
                                xRight,
                                2 * yScroll + (yMax - yCircle) + kRightOffset);
//      circle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
      break;
    }
    default:
      break;
  }
  
  [circle drawCircleForYScreen:yCircle - yScroll];
}

// -----------------------------------------------------------------------------
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
      if (changed) { // Reclassification
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
