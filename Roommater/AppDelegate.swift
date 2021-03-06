//
//  AppDelegate.swift
//  Roommater
//
//  Created by Drew on 1/17/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        
//        EventController.shared.createEvent(name: "my first event", description: "asda", user: Interb
//            }
//        }
//        
        
        //        PlaceController.shared.createPlace(adminUid: "grUKp19eBVPT2UKZJ8s9emzAGDm2", placeName: "MY new place", homeAddress: "123 St.") { (place) inb        //
        //        }
        //        let db = Firestore.firestore()
        //        let settings = db.settings
        //        settings.areTimestampsInSnapshotsEnabled = true
        //        db.settings = settings
        //
        //        let dueDate = Date(timeIntervalSinceNow: 2000)
        //        b
        //        TaskController.shared.createTask(withName: "testName", dueDate: dueDate) { (success) in
        //            if success {
        //                print(">>> HELLYEAH")
        //            } else {
        //                print(">>> HELLNO")
        //            }
        //        }
        
        //        Database.database().isPersistenceEnabled = true
        //        InternalUserController.shared.createUser(fullname: "greg", emailAddress: "test5@gmail.com", password: "123456", phoneNumber: "2223333") { (user) in
        //
        //            guard let user = InternalUserController.shared.loggedInUser else {return}
        //
        
        //            PlaceController.shared.createPlace(adminUid: user, placeName: "testPlace1", completion: { (_) in
        //            PlaceController.shared.createPlace(admin: user, placeName: "testPlace1", completion: { (_) in
        //
        //            })
        //                EventController.shared.createEvent(place: PlaceController.shared.currentPlace!, user:  InternalUserController.shared.loggedInUser!, name: "ad", date: Date(), completion: { (success) in
        //
        //                })
        
        
        
        
        //        }
        //        }
        
        //local persistence
        
        // Override point for customization after application launch.
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

