//
//  SERAppDelegate.m
//  SERPickerControllerDemo
//
//  Created by Stanley Rost on 21.03.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import "SERAppDelegate.h"
#import "SERPickerDemoViewController.h"

@implementation SERAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  self.window.rootViewController = [SERPickerDemoViewController new];
  
  return YES;
}

@end
