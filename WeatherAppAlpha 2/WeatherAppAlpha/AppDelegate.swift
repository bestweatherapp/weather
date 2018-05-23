//
//  AppDelegate.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 07.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let city = FetchCities() {
            cities = city
        } else {
            cities = [String]()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       // Release shared resources, invalidate timers, and store enough app state information to restore your app to its current state in case it is terminated later
        SaveCity(cities: cities!)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Perform any final clean-up tasks for your app, such as freeing shared resources, saving user data, and invalidating timers
         SaveCity(cities: cities!)
    }
}

