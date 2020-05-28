//
//  AppDelegate.swift
//  BarberApp
//
//  Created by iOS8 on 05/03/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import CoreLocation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var mapViw: GMSMapView!



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyCezEmxGKtPLCTpb_jEife31PnfJuICegc")
        // Override point for customization after application launch.
        
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        self.mapViw?.isMyLocationEnabled = true
        mapViw?.delegate = self


        //.locationManager.startUpdatingLocation()

        
        if #available(iOS 13.0, *) {
            
            // In iOS 13 setup is done in SceneDelegate
            
        } else {
            
            
            
            
            let apiToken = UserDefaults.standard.value(forKey: DefaultsIdentifier.apiToken)
            
            if apiToken is String {
                
                let window = UIWindow(frame: UIScreen.main.bounds)
                self.window = window
  
                let newViewcontroller = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVcViewController") as! TabBarVcViewController
                window.rootViewController = newViewcontroller
                
            } else {
                
                
            }
            
        }
        
        
        
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BarberApp")
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

}

