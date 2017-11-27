//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 25/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var continentSelected : String = ""
    var countrySelected  : String = ""
    var provinceSelected  : String = ""
    var citySelected  : String = ""

    
    var arraySideMenuItems : [MenuItem] = [MenuItem]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
  
        if (UserDefaults.standard.object(forKey: "lastCityId") != nil) {
            citySelected = UserDefaults.standard.string(forKey: "lastCityId")!
        }
        else{
            print("Key Does Exist")

        }
        
        //Initial Favourite management
//        if let data = UserDefaults.standard.data(forKey: "favorites"),
//            let myFavouriteList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FavoriteCity] {
//            let encodedData = NSKeyedArchiver.archivedData(withRootObject: myFavouriteList)
//            UserDefaults.standard.set(encodedData, forKey: "favorites")
//            citySelected = (myFavouriteList.last?.id)!
//        }

        return true
    }
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func creadorAlertView(texto : String , titulo : String){
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // continue your work
            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow.isHidden = true
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: nil)
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

