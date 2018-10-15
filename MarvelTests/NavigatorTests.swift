//
//  NavigatorTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import XCTest
@testable import Marvel

class NavigatorTests: XCTestCase {
    func testListDestinationCreatesListView() {
        let viewController = Navigator.makeViewController(for: .list)
        XCTAssertTrue(viewController is CharactersListViewController)
    }

    func testDetailsDestinationCreatesDetailsView() {
        let viewController = Navigator.makeViewController(for: .details(makeCharacter()))
        XCTAssertTrue(viewController is CharacterDetailsViewController)
    }

    func testExistentDestinationIsNotReAddedToStack() {
        let window = UIWindow()
        let firstDestination = Destination.list
        let navigator = Navigator(rootDestination: firstDestination, window: window)
        XCTAssertEqual(navigator.currentDestination, firstDestination)
        XCTAssertEqual(navigator.destinationsCount, 1)

        let secondDestination = Destination.details(makeCharacter())

        navigator.navigate(to: secondDestination)
        XCTAssertEqual(navigator.currentDestination, secondDestination)
        XCTAssertEqual(navigator.destinationsCount, 2)

        navigator.navigate(to: firstDestination)
        XCTAssertEqual(navigator.currentDestination, firstDestination)
        XCTAssertEqual(navigator.destinationsCount, 1)
    }

    private func makeCharacter() -> Marvel.Character {
        let sample =
        """
        {
        "id": 1017100
        }
        """
        let decoder = Decoding.decoder
        return try! decoder.decode(Character.self, from: sample.data(using: .utf8)!)
    }
}
