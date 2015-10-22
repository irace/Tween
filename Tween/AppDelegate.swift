//
//  AppDelegate.swift
//  Tween
//
//  Created by Bryan Irace on 10/22/15.
//  Copyright © 2015 Bryan Irace. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: ViewController())
        navigationController.toolbarHidden = false
        navigationController.navigationBarHidden = true
        navigationController.toolbar.tintColor = UIColor.whiteColor()
        navigationController.toolbar.barTintColor = UIColor.blackColor()
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
