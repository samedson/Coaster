//
//  CGUtil.h
//  Coaster
//
//  Created by Samuel Edson on 7/22/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

CG_INLINE CGRect
CGRectMove(CGRect rect, CGFloat x, CGFloat y)
{
  return CGRectMake(x, y, rect.size.width, rect.size.height);
}