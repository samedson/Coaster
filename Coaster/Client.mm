//
//  Client.m
//  Coaster
//
//  Created by Samuel Edson on 8/3/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "Client.h"

#import "WebUtil.h"

// -----------------------------------------------------------------------------

Client *globalClient = nil;

// -----------------------------------------------------------------------------

@interface Client()

@property (nonatomic, strong) NSURL *ec2UrlBase;

@end

// -----------------------------------------------------------------------------

@implementation Client

+ (Client *)client {
  Client *client = [[Client alloc] init];
  return client;
}

- (id)init {
  self  = [super init];
  if ( ! self) { return nil; }
  
  self.ec2UrlBase = [NSURL URLWithString:@"http://ec2-54-186-123-23.us-west-2.compute.amazonaws.com/coasterserver/"];
  
  return self;
}

- (bool)getTest {
  NSLog(@"getTest");
  NSMutableDictionary *request = [[NSMutableDictionary alloc]
      initWithObjectsAndKeys:@"some number", @"key",
                             nil];
  NSString *service = @"friends";
  NSDictionary *response = [self postRequest:request
                                 withService:service];
  NSLog(@"response: %@", response);
  return false;
}

- (NSDictionary *)postRequest:(NSDictionary *)request
                  withService:(NSString *)service {
  NSString *name = [NSString stringWithFormat:@"handler%@", service];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",
                                     self.ec2UrlBase, name, @"handler.py"]];
  NSLog(@"%@", [url absoluteString]);
  return [WebUtil postRequest:request
                      withURL:url];
}

@end
