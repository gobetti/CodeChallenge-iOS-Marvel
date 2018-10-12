//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import XCTest
@testable import Marvel

class MarvelTests: XCTestCase {
    func testCharactersDecodingSucceeds() {
        let bundle = Bundle(for: type(of: self))
        let jsonFileURL = bundle.url(forResource: "characters_sample", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonFileURL)
        let swiftType = CharacterDataWrapper.self
        let decoder = swiftType.decoder
        let dataWrapper = try! decoder.decode(swiftType, from: jsonData)

        XCTAssertGreaterThan(dataWrapper.data!.results!.count, 0)
    }
}
