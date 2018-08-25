//
//  AppDelegate.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(
            name: UIStoryboard.Storyboard.main.filename,
            bundle: nil)
        if let viewController: ViewController =  storyboard.instantiateViewController()
        {
            self.window?.rootViewController = viewController
        }
        self.window?.makeKeyAndVisible()
        return true
    }
}
