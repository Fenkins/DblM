//
//  AppDelegate.m
//  Дым
//
//  Created by Fenkins on 01/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse.h>
#import <Bolts.h>
#import <Reachability.h>

@interface AppDelegate () {
    Reachability* internetReachableCheck;
}

@end

@implementation AppDelegate
-(void)testInternetConnection {
    internetReachableCheck = [Reachability reachabilityWithHostName:@"www.google.com"];
    // If internet is reachable
    internetReachableCheck.reachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"yea");
        });
    };
    // If internet is not reachable
    internetReachableCheck.unreachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"nope");
        });
    };
    [internetReachableCheck startNotifier];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Running that method up there to check if we are connected to the internets
    [self testInternetConnection];
    
    // We DO want local dataStore
    [Parse enableLocalDatastore];
    // Initializing Parse
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
