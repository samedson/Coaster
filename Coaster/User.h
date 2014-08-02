//
//  User.h
//  Coaster
//
//  Created by Samuel Edson on 7/25/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

// -----------------------------------------------------------------------------

@interface User : NSObject

- (id)initWithUserImage:(UIImage *)image;

- (bool)hasUserImage;
- (UIImage *)getUserImage;

- (UIColor *)getColor;
- (void)setColorForUser:(UIColor *)color;

@end
