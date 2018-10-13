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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        if NSClassFromString("XCTest") != nil {
            // Running unit tests, let's prevent UI from loading and concurring
            window.rootViewController = UIViewController()
        } else {
            let viewModel: CharactersListViewModel
            if CommandLine.arguments.contains("--uitesting") {
                let sample =
                """
                {
                  "data": {
                    "results": [
                      {
                        "id": 1011334,
                        "name": "3-D Man"
                      }
                    ]
                  }
                }
                """.data(using: .utf8)! // swiftlint:disable:this force_unwrapping
                let service = MarvelService(stubBehavior: .immediate(stub: .success(sample)),
                                            scheduler: MainScheduler.instance)
                viewModel = CharactersListViewModel(service: service)
            } else {
                viewModel = CharactersListViewModel()
            }
            
            let viewController = CharactersListViewController(viewModel: viewModel)
            window.rootViewController = UINavigationController(rootViewController: viewController)
        }
        window.makeKeyAndVisible()

        return true
    }
}
