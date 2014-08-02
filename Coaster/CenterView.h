//
//  CenterView.h
//  Coaster
//
//  Created by Samuel Edson on 7/22/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

// -----------------------------------------------------------------------------

@interface CenterView : UIView

- (id)initWithFrame:(CGRect)frame;

- (void)reloadColors;

- (void)loadUser:(User *)user;

@end
