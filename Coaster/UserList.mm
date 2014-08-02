//
//  UserList.m
//  Coaster
//
//  Created by Samuel Edson on 7/29/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "UserList.h"

// -----------------------------------------------------------------------------

UserList *globalUserList = NULL;

UserList::UserList() {
  friendsList_ = [[NSMutableArray alloc] init];
  
  currentUser_ = [[User alloc] initWithUserImage:[UIImage imageNamed:@"user2.jpg"]];
  
  // EXAMPLE USERS
  for (int i = 0; i <= 13; i++) {
    NSString *imageName = [NSString stringWithFormat:@"user%i.jpg", i];
    UIImage *userImage = [UIImage imageNamed:imageName];
    [friendsList_ addObject:[[User alloc] initWithUserImage:userImage]];
  }
}

UserList::~UserList() {
  
}

User * UserList::getUserForIndex(NSInteger index) {
  return friendsList_[index % friendsList_.count];
}

User * UserList::getCurrentUser() {
  return currentUser_;
}

UIColor * UserList::getCurrentUserColor() {
  return [currentUser_ getColor];
}

void UserList::setCurrentUserColor(UIColor *newColor) {
  [currentUser_ setColorForUser:newColor];
}