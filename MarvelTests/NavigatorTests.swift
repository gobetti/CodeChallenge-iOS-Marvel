//
//  NavigatorTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import XCTest
@testable import Marvel

class NavigatorTests: XCTestCase {
    func testExistentDestinationIsNotReAddedToStack() {
        let window = UIWindow()
        var navigator: Navigator!
        let firstDestination = Destination.list({ navigator })
        navigator = Navigator(rootDestination: firstDestination, window: window)
        XCTAssertEqual(navigator.currentDestination, firstDestination)
        XCTAssertEqual(navigator.destinationsCount, 1)

        let secondDestination = Destination.details(Character(id: 1, name: nil, comics: nil))

        navigator.navigate(to: secondDestination)
        XCTAssertEqual(navigator.currentDestination, secondDestination)
        XCTAssertEqual(navigator.destinationsCount, 2)

        navigator.navigate(to: firstDestination)
        XCTAssertEqual(navigator.currentDestination, firstDestination)
        XCTAssertEqual(navigator.destinationsCount, 1)
    }
}
