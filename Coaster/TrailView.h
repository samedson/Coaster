//
//  TrailView.h
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrailView : UIView

@end

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