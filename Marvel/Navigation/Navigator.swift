//
//  Navigator.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

typealias Destination = ViewControllerFactory

final class Navigator {
    private let navigationController: UINavigationController
    private var destinationStack = [Destination]()

    var currentDestination: Destination? {
        return destinationStack.last
    }

    var destinationsCount: Int {
        return destinationStack.count
    }

    init(rootDestination: Destination, window: UIWindow) {
        destinationStack.append(rootDestination)
        let rootViewController = rootDestination.makeViewController()
        navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
    }

    func navigate(to destination: Destination) {
        while destinationStack.contains(destination), destinationStack.last != destination {
            navigationController.popViewController(animated: true)
            _ = destinationStack.popLast()
        }

        guard destinationStack.last != destination else { return }

        destinationStack.append(destination)
        let viewController = destination.makeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
