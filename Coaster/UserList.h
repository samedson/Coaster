//
//  UserList.h
//  Coaster
//
//  Created by Samuel Edson on 7/29/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

// -----------------------------------------------------------------------------

class UserList {
public:
  UserList();
  ~UserList();
  
  User *getUserForIndex(NSInteger index);
  User *getCurrentUser();
  UIColor *getCurrentUserColor();
  void setCurrentUserColor(UIColor *newColor);
private:
  User *currentUser_;
  NSMutableArray *friendsList_;
};

// -----------------------------------------------------------------------------

extern UserList *globalUserList;