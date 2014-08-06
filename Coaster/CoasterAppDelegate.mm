//
//  CoasterAppDelegate.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CoasterAppDelegate.h"

#import <Parse/Parse.h>

#import "RootViewController.h"

#import "Client.h"
#include "UserList.h"

@implementation CoasterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // --- Parse ---------------------------------------------------------------------
  [Parse setApplicationId:@"nC5B3OPfZguNWzcim7JflXZddZLjfpxveGkyjr3q"
                clientKey:@"bFIkwOc84tyU2ffdssw6m6mdY4f1dreadyyCF72A"];
  PFACL *defaultACL = [PFACL ACL];
  [defaultACL setPublicReadAccess:YES];
  [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
  // --- Parse ---------------------------------------------------------------------

  globalUserList = new UserList();
  globalClient = [Client client];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = [[RootViewController alloc] init];
  [self.window makeKeyAndVisible];
  
  // --- Parse ---------------------------------------------------------------------
  if (application.applicationState != UIApplicationStateBackground) {
    // Track an app open here if we launch with a push, unless
    // "content_available" was used to trigger a background push (introduced
    // in iOS 7). In that case, we skip tracking here to avoid double
    // counting the app-open.
    BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
    BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
    BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
      [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    }
  }
  [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
   UIRemoteNotificationTypeAlert |
   UIRemoteNotificationTypeSound];
  // --- Parse ---------------------------------------------------------------------
  
  return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [PFPush storeDeviceToken:deviceToken];
  [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
  
  // Store the deviceToken in the current installation and save it to Parse.
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData:deviceToken];
  [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  // --- Parse ---------------------------------------------------------------------
  if (error.code == 3010) {
    NSLog(@"Push notifications are not supported in the iOS Simulator.");
  } else {
    // show some alert or otherwise handle the failure to register.
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
  // --- Parse ---------------------------------------------------------------------
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  // --- Parse ---------------------------------------------------------------------
  [PFPush handlePush:userInfo];
  
  if (application.applicationState == UIApplicationStateInactive) {
    [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
  }
  // --- Parse ---------------------------------------------------------------------
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // --- Parse ---------------------------------------------------------------------
  if (application.applicationState == UIApplicationStateInactive) {
    [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
  }
  // --- Parse ---------------------------------------------------------------------
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Parse

// --- Parse ---------------------------------------------------------------------
- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
  if ([result boolValue]) {
    // It works
  } else {
    NSLog(@"Failed to subscribe to push notifications on the broadcast channel.");
  }
}
// --- Parse ---------------------------------------------------------------------

@end
