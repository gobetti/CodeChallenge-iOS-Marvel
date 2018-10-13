//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import XCTest

class MarvelUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testAnyCellIsCreated() {
        XCTAssertTrue(app.collectionViews.cells.firstMatch.exists)
    }
}
