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
            return CharacterDetailsViewController(character: character,
                                                  viewModel: makeCharacterDetailsViewModel())

        case .list:
            let onCharacterSelected: CharactersListViewController.OnCharacterSelected = {
                instance.navigate(to: .details($0))
            }

            return CharactersListViewController(viewModel: makeCharactersListViewModel(),
                                                onCharacterSelected: onCharacterSelected)
        }
    }

    private static func makeCharacterDetailsViewModel() -> CharacterDetailsViewModel {
        if isUITesting {
            let sample =
            """
            {
              "data": {
                "results": [
                  {
                    "id": 1011334,
                    "title": "Avengers: The Initiative (2007) #14",
                    "description": "The fates of The Initiative, the United States, and Planet Earth..."
                  }
                ]
              }
            }
            """.data(using: .utf8)! // swiftlint:disable:this force_unwrapping
            let service = MarvelService(stubBehavior: .immediate(stub: .success(sample)))
            return CharacterDetailsViewModel(service: service)
        } else {
            return CharacterDetailsViewModel()
        }
    }

    private static func makeCharactersListViewModel() -> CharactersListViewModel {
        if isUITesting {
            let sample =
            """
            {
              "data": {
                "results": [
                  {
                    "id": 1011334,
                    "name": "3-D Man",
                    "comics": {
                      "items": [
                        {
                          "resourceURI": "http://gateway.marvel.com/v1/public/comics/40632"
                        }
                      ]
                    }
                  }
                ]
              }
            }
            """.data(using: .utf8)! // swiftlint:disable:this force_unwrapping
            let service = MarvelService(stubBehavior: .immediate(stub: .success(sample)))
            return CharactersListViewModel(service: service)
        } else {
            return CharactersListViewModel()
        }
    }

    private static var isUITesting: Bool {
        return CommandLine.arguments.contains("--uitesting")
    }
}
