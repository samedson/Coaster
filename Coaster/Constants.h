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
static const CGFloat kCellRadius = 26;
static const NSInteger kCellsPerPage = 26;
static const NSInteger kNumberOfCells = kCellsPerPage + 2;
static const NSInteger kPageSize = (2 * kCellRadius * kNumberOfCells - 3);
static const NSInteger kContentSize = 5000 * kPageSize;

// Deciding which mode
static const NSInteger kModeCutoffLeft_RightY = 0;
static const NSInteger kModeCutoffBottomLeft_LeftY = 570;
static const NSInteger kModeCutoffBottomLeft_BottomX = 24;
static const NSInteger kModeCutoffBottomRight_BottomX = 232;
static const NSInteger kModeCutoffBottomRight_RightY = 840;
static const NSInteger kModeCutoffRight_LeftY = 1350;

// Borders
static const CGFloat kBorderWidth = 3.0f;

// CenterView
static const CGFloat kCenterBarHeight = 2 * kCellRadius;

#endif
