//
//  AppDelegate.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //设置唤醒调用最小时间 后台运行
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        let mapManager = BMKMapManager()
        mapManager.start("z29pXnxczTLDZ6pZG7LMYcQqLodyQ8zh", generalDelegate: nil)
        Growing.start(withAccountId: "944396c52dd53e96")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "growing.a1474e274f7d60ae"  {
            return Growing.handle(url)
        }
        
        return false
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "growing.a1474e274f7d60ae"  {
            return Growing.handle(url)
        }
        
        return false
    }

//    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        
//        application.applicationIconBadgeNumber += 1
//    }
}

