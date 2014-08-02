//
//  UIColor.m
//  Coaster
//
//  Created by Samuel Edson on 7/25/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "UIColor+Stylesheet.h"

#include <stdlib.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (Stylesheet)

+ (UIColor *)colorWithIntRed:(int)red green:(int)green blue:(int)blue {
  return [UIColor colorWithIntRed:red green:green blue:blue alpha:255];
}

+ (UIColor *)colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
  return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

+ (UIColor *)randomColor {
  int r = arc4random() % 9;
  switch (r) {
    case 0: return [UIColor appleRed];
    case 1: return [UIColor appleRedOrange];
    case 2: return [UIColor appleOrange];
    case 3: return [UIColor appleYellow];
    case 4: return [UIColor appleGreen];
    case 5: return [UIColor appleBlueLight];
    case 6: return [UIColor appleBlueTourquoise];
    case 7: return [UIColor appleBlue];
    case 8: return [UIColor applePurple];
    default:
      break;
  }
  return [UIColor appleRed];
}

+ (UIColor *)appleRed {
  return [UIColor colorWithIntRed:255 green:45 blue:85];
}

+ (UIColor *)appleRedOrange {
  return [UIColor colorWithIntRed:255 green:59 blue:48];
}

+ (UIColor *)appleOrange {
  return [UIColor colorWithIntRed:255 green:149 blue:0];
}

+ (UIColor *)appleYellow {
  return [UIColor colorWithIntRed:255 green:204 blue:0];
}

+ (UIColor *)appleGreen {
  return [UIColor colorWithIntRed:76 green:217 blue:100];
}
+ (UIColor *)appleBlueLight {
  return [UIColor colorWithIntRed:90 green:200 blue:250];
}

+ (UIColor *)appleBlueTourquoise {
  return [UIColor colorWithIntRed:52 green:170 blue:220];
}

+ (UIColor *)appleBlue {
  return [UIColor colorWithIntRed:0 green:122 blue:255];
}

+ (UIColor *)applePurple {
  return [UIColor colorWithIntRed:88 green:86 blue:214];
}

@end
