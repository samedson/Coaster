//
//  CircleImageView.h
//  Coaster
//
//  Created by Samuel Edson on 8/2/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleImageView : UIButton

- (id)initWithOrigin:(CGPoint)origin
              radius:(CGFloat)radius
               image:(UIImage *)image;

- (void)setImage:(UIImage *)image;

@end
