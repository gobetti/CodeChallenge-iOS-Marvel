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

    func testAnyCellIsCreatedInListView() {
        XCTAssertTrue(anyCell.exists)
    }

    func testCharacterTapOpensCorrespondingDetails() {
        let characterName = anyCell.staticTexts.firstMatch.label
        anyCell.tap()
        XCTAssertTrue(app.otherElements["detailsView"].exists)
        XCTAssertTrue(app.navigationBars[characterName].exists)
    }

    func testAnyCellIsCreatedInDetailsView() {
        anyCell.tap()
        XCTAssertTrue(app.otherElements["detailsView"].exists)
        XCTAssertTrue(anyCell.exists)
    }

    func testCellSizeChangesAfterRotation() {
        XCUIDevice.shared.orientation = .portrait
        let cellWidthOnPortrait = anyCell.frame.size.width

        XCUIDevice.shared.orientation = .landscapeRight
        XCTAssertNotEqual(anyCell.frame.size.width, cellWidthOnPortrait)
    }

    private var anyCell: XCUIElement {
        return app.collectionViews.cells.firstMatch
    }
}
