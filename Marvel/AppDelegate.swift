//
//  AppDelegate.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var navigator: Navigator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GlobalAppearance.apply()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let rootDestination = ViewControllerFactory.list({ self.navigator })
        navigator = Navigator(rootDestination: rootDestination, window: window)
        window.makeKeyAndVisible()

        return true
    }
}
