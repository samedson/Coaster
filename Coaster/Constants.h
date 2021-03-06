//
//  Constants.h
//  Coaster
//
//  Created by Samuel Edson on 8/2/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#ifndef Coaster_Constants_h
#define Coaster_Constants_h

// Cells
static const CGFloat kCellRadius = 28;
static const NSInteger kCellsPerPage = 26;
static const NSInteger kNumberOfCells = kCellsPerPage + 2;
static const NSInteger kPageSize = (2 * kCellRadius * kNumberOfCells - 3);
// 922,337,203,685,477, ~76886037 miles, ~3087.5 times around Earth
static const NSInteger kContentSize = LONG_MAX / 10000;

// Deciding which mode
static const NSInteger kModeCutoffLeft_RightY = 0;
static const NSInteger kModeCutoffBottomLeft_LeftY = 568;
static const NSInteger kModeCutoffBottomLeft_BottomX = 33;
static const NSInteger kModeCutoffBottomRight_BottomX = 231;
static const NSInteger kModeCutoffBottomRight_RightY = 832;
static const NSInteger kModeCutoffRight_LeftY = 1350;

// Borders
static const CGFloat kBorderWidth = 3.0f;

// CenterView
static const CGFloat kCenterBarHeight = 2 * kCellRadius;

#endif
