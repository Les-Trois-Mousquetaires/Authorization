//
//  AppDelegate.swift
//  Authorization
//
//  Created by 柯南 on 2020/9/4.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = ViewController()
        vc.view.backgroundColor = .yellow
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        return true
    }

    
}

