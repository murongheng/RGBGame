//
//  AppDelegate.m
//  RGBGame
//
//  Created by 千锋 on 16/2/25.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "WGArchiverManager.h"
#define TASK_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/RGRGame.data"]

@interface AppDelegate ()

@end

@implementation AppDelegate {
    ViewController *_vc;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _vc = [[ViewController alloc] init];
    _myTask = [WGArchiverManager unarchiverObjectforKey:@"task" inPath:TASK_PATH];
    _vc.myTask = _myTask;
    _vc.myTask.animation = 0;
    [_window makeKeyAndVisible];
    _window.rootViewController = _vc;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
    if (_vc.myTask.checkPoint < 11) {
        [WGArchiverManager archiverObject:_vc.myTask forKey:@"task" inPath:TASK_PATH];
      
    }
    
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
