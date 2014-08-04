//
//  Client.h
//  Coaster
//
//  Created by Samuel Edson on 8/3/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

// -----------------------------------------------------------------------------

@interface Client : NSObject

+ (Client *)client;

- (bool)getTest;

@end

// -----------------------------------------------------------------------------

extern Client *globalClient;