//
//  ViewControllerFactory.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 19/10/18.
//

import Foundation
import UIKit

typealias NavigationGetter = () -> Navigator

enum ViewControllerFactory: Equatable {
    case details(Character)
    case list(NavigationGetter)

    static func == (lhs: ViewControllerFactory, rhs: ViewControllerFactory) -> Bool {
        switch (lhs, rhs) {
        case let (.details(char1), .details(char2)):
            return char1 == char2
        case (.list, .list):
            return true
        default:
            return false
        }
    }

    func makeViewController() -> UIViewController {
        switch self {
        case .details(let character):
            return CharacterDetailsViewController(character: character,
                                                  viewModel: type(of: self).makeCharacterDetailsViewModel())

        case .list(let navigator):
            let onCharacterSelected: CharactersListViewController.OnCharacterSelected = {
                navigator().navigate(to: .details($0))
            }

            return CharactersListViewController(viewModel: type(of: self).makeCharactersListViewModel(),
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
