//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let initialViewController = MainRouter.assembleModules()
        let navigationController = UINavigationController(rootViewController: initialViewController)
        window?.rootViewController = navigationController

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }       
        window?.makeKeyAndVisible()
        
        return true
    }


}

