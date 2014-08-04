//
//  WebUtil.m
//  Coaster
//
//  Created by Samuel Edson on 8/3/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "WebUtil.h"

@implementation WebUtil


+ (NSDictionary *)postRequest:(NSDictionary *)request
                      withURL:(NSURL *)url
                 withMaxRetry:(NSInteger)maxRetry {
  return nil;
}

+ (NSDictionary *)postRequest:(NSDictionary *)request
                      withURL:(NSURL *)url
{
  NSData *postData = [NSJSONSerialization dataWithJSONObject:request
                                                     options:0
                                                       error:nil];
  NSString *postLength = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[postData length]];

  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
  [urlRequest setURL:url];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setValue:postLength
    forHTTPHeaderField:@"Content-Length"];
  [urlRequest setValue:@"application/x-www-form-urlencoded"
    forHTTPHeaderField:@"Content-Type"];
  [urlRequest setHTTPBody:postData];
    
  NSURLResponse *urlResponse = nil;
  NSError *error = nil;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
                                               returningResponse:&urlResponse
                                                           error:&error];
  
  if (error) {
    NSLog(@"PostRequestwithUrl error:\n   %@", error);
    return nil;
  } else if (responseData == nil || [responseData length] == 0) {
    NSLog(@"PostRequestwithUrl responded with no data.");
    return nil;
  } else {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:&error];
    if (error) {
      NSLog(@"PostRequestwithUrl serialization error:\n   %@", error);
      return nil;
    } else {
      return response;
    }
  }
}

@end
