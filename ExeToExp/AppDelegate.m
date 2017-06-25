//
//  AppDelegate.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarCtrl.h"
#import "AFNetTool.h"
#import <AMapFoundationKit/AMapFoundationKit.h>//高德基础地图
#import <AMapLocationKit/AMapLocationKit.h>//高德定位服务

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[MyTabBarCtrl alloc] init];
    
    
    //高德定位服务
    [AMapServices sharedServices].apiKey = @"afcaf49546e12ad2623d89e31dd465af";
    
    AFNetTool *afntool = [[AFNetTool alloc] init];
    [afntool currentNetStatus:^(BOOL isConnect, AFNetworkReachabilityStatus currentStatus) {
        DLog(@"%@",isConnect?@"YES":@"NO");
        switch (currentStatus) {
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知的网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                DLog(@"网络未连接");
                [UIView addMJNotifierWithText:@"连接失败，请检查网络或重试" dismissAutomatically:YES];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"WIFI网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"手机网络");
                break;
            default:
                break;
        }
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
