//
//  CornerButton.h
//  Coaster
//
//  Created by Samuel Edson on 7/28/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrailView.h"

// -----------------------------------------------------------------------------

@interface CornerButton : UIButton

- (id)initWithFrame:(CGRect)frame
       leftTriangle:(bool)leftTriangle
             parent:(TrailView *)parent;

- (void)handleTap;

- (void)setFillColorNew:(UIColor *)newFillColor;

@end
