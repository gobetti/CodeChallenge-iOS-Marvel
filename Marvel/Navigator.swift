//
//  Navigator.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

enum Destination: Equatable {
    case details(Character)
    case list
}

final class Navigator {
    private static var instance: Navigator!

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
        let rootViewController = type(of: self).makeViewController(for: rootDestination)
        navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController

        Navigator.instance = self
    }

    func navigate(to destination: Destination) {
        while destinationStack.contains(destination), destinationStack.last != destination {
            navigationController.popViewController(animated: true)
            _ = destinationStack.popLast()
        }

        guard destinationStack.last != destination else { return }

        destinationStack.append(destination)
        let viewController = Navigator.makeViewController(for: destination)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .details(let character):
            return CharacterDetailsViewController(character: character)
        case .list:
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
                let service = MarvelService(stubBehavior: .immediate(stub: .success(sample)))
                viewModel = CharactersListViewModel(service: service)
            } else {
                viewModel = CharactersListViewModel()
            }

            let onCharacterSelected: CharactersListViewController.OnCharacterSelected = {
                instance.navigate(to: .details($0))
            }

            return CharactersListViewController(viewModel: viewModel,
                                                onCharacterSelected: onCharacterSelected)
        }
    }
}
