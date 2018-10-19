//
//  ViewControllerFactoryTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 19/10/18.
//

import XCTest
@testable import Marvel

class ViewControllerFactoryTests: XCTestCase {
    func testListCaseCreatesListView() {
        let navigator: Navigator? = nil
        let viewController = ViewControllerFactory.list({ navigator! }).makeViewController()
        XCTAssertTrue(viewController is CharactersListViewController)
    }

    func testDetailsCaseCreatesDetailsView() {
        let character = Character(id: 1, name: nil, comics: nil)
        let viewController = ViewControllerFactory.details(character).makeViewController()
        XCTAssertTrue(viewController is CharacterDetailsViewController)
    }
}
