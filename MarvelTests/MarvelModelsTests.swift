//
//  MarvelModelsTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import XCTest
@testable import Marvel

class MarvelModelsTests: XCTestCase {
    let sample1 =
    """
    {
    "id": 1011334
    }
    """

    let sample2 =
    """
    {
    "id": 1017100
    }
    """

    private func model<T: Codable>(fromSample sample: String) -> T {
        let decoder = Decoding.decoder
        return try! decoder.decode(T.self, from: sample.data(using: .utf8)!)
    }

    func testCharactersWithSameIdAreEqual() {
        let character1: Marvel.Character = model(fromSample: sample1)
        let character2: Marvel.Character = model(fromSample: sample1)
        XCTAssertEqual(character1, character2)
    }

    func testCharactersWithDifferentIdsAreNotEqual() {
        let character1: Marvel.Character = model(fromSample: sample1)
        let character2: Marvel.Character = model(fromSample: sample2)
        XCTAssertNotEqual(character1, character2)
    }

    func testComicsWithSameIdAreEqual() {
        let comic1: Comic = model(fromSample: sample1)
        let comic2: Comic = model(fromSample: sample1)
        XCTAssertEqual(comic1, comic2)
    }

    func testComicsWithDifferentIdsAreNotEqual() {
        let comic1: Comic = model(fromSample: sample1)
        let comic2: Comic = model(fromSample: sample2)
        XCTAssertNotEqual(comic1, comic2)
    }
}
