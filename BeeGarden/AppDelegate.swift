//
//  AppDelegate.swift
//  BeeGarden
//
//  Created by steven liu on 3/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications
import GlidingCollection

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    var databaseController : DatabaseProtocol?     // coredata
    //var persistantContainer: NSPersistentContainer?
    
    var locationManager: CLLocationManager!
    var notificationCenter: UNUserNotificationCenter!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        databaseController = CoreDataController()   //  coredata
        
//        persistantContainer = NSPersistentContainer(name: "Model")
//               persistantContainer?.loadPersistentStores() { (description, error) in
//                   if let error = error {
//                       fatalError("Failed to load Core Data stack: \(error)")
//                   }
//               }
        
               
               self.locationManager = CLLocationManager()
               self.locationManager!.delegate = self
               
               // get the singleton object
               self.notificationCenter = UNUserNotificationCenter.current()
               
               // register as it's delegate
               notificationCenter.delegate = self
               
               // define what do you need permission to use
               let options: UNAuthorizationOptions = [.alert, .sound]
               
               // request permission
               notificationCenter.requestAuthorization(options: options) { (granted, error) in
                   if !granted {
                       print("Permission not granted")
                   }
               }
               
               if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
                   print("I woke up thanks to geofencing")
               }
               //modified from lecture resource
               let uiNavbarProxy = UINavigationBar.appearance()
        uiNavbarProxy.barTintColor = UIColor(displayP3Red: 244/255, green: 189/255, blue: 32/255, alpha: 0.8)
               uiNavbarProxy.tintColor = UIColor.white
               uiNavbarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let uiTabbarProxy = UITabBar.appearance()
        uiTabbarProxy.barTintColor = UIColor(displayP3Red: 244/255, green: 189/255, blue: 32/255, alpha: 0.8)
        uiTabbarProxy.tintColor = UIColor.black
      // uiTabbarProxy.isTranslucent = false
        
        //page control color for tutorial pages
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = UIColor(displayP3Red: 244/255, green: 189/255, blue: 32/255, alpha: 1.0)
        pageControl.pageIndicatorTintColor = .lightGray
        
        
        setupGlidingCollection()
        return true
    }
    
    private func setupGlidingCollection() {
      var config = GlidingConfig.shared
      config.buttonsFont = UIFont.boldSystemFont(ofSize: 22)
      config.inactiveButtonsColor = config.activeButtonColor
      GlidingConfig.shared = config
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func handleEvent(forRegion region: CLRegion!, entry : Bool) {
           
           // customize your notification content
           let content = UNMutableNotificationContent()
           content.title = region.identifier
           if entry == true {
               content.body = "Welcome to \(region.identifier) !"
               
           }
           else {
               content.body = "You have Exit \(region.identifier) !"
               
           }
           
           content.sound = UNNotificationSound.default
           
           // when the notification will be triggered
           let timeInSeconds: TimeInterval = 3
           // the actual trigger object
           let trigger = UNTimeIntervalNotificationTrigger(
               timeInterval: timeInSeconds,
               repeats: false
           )
           
           // notification unique identifier, for this example, same as the region to avoid duplicate notifications
           let identifier = region.identifier
           
           // the notification request object
           let request = UNNotificationRequest(
               identifier: identifier,
               content: content,
               trigger: trigger
           )
           
           // trying to add the notification request to notification center
           notificationCenter.add(request, withCompletionHandler: { (error) in
               if error != nil {
                   print("Error adding notification with identifier: \(identifier)")
               }
           })
       }
    
    
}
extension AppDelegate: CLLocationManagerDelegate {
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region, entry: false)
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region,entry: false)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        print(identifier)
        // ...
    }
}







