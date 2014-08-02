//
//  ExtraScrollView.h
//  Coaster
//
//  Created by Samuel Edson on 7/28/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrailView.h"

// -----------------------------------------------------------------------------

@interface ExtraScrollView : UIScrollView

- (id)initWithFrame:(CGRect)frame
             parent:(TrailView *)parent;

@end
