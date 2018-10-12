//
//  AppDelegate.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        if NSClassFromString("XCTest") != nil {
            // Running unit tests, let's prevent UI from loading and concurring
            window.rootViewController = UIViewController()
        } else {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
            window.rootViewController = UINavigationController(rootViewController: viewController)
        }
        window.makeKeyAndVisible()

        return true
    }
}

