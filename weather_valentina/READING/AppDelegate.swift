//
//  AppDelegate.swift
//  READING
//
//  Created by Валентина on 07.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let notificationDelegate = UYLNotificationDelegate()
    var window: UIWindow?
    var FirstView : ViewController?
    var notificationComment : String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       
        return true
    }

   
    
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
        print("GoodBye")
        applicationWillTerminate(application)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
        if CheckInternet.Connection()
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = notificationDelegate
            // from stackiverflow (while background?) WOOOOOORKS
            
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = ""
            localNotification.alertBody = "Don't forget to check current weather"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 7) as Date
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Sorry, no onternet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            alert.present(alert, animated: true)
            applicationWillTerminate(application)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print ("Hello")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "READING")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

