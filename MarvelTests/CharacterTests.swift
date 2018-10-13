//
//  CharacterTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import XCTest
@testable import Marvel

class CharacterTests: XCTestCase {
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

    private func character(fromSample sample: String) -> Marvel.Character {
        let decoder = CharacterDataWrapper.decoder
        return try! decoder.decode(Character.self, from: sample.data(using: .utf8)!)
    }

    func testCharactersWithSameIdAreEqual() {
        XCTAssertEqual(character(fromSample: sample1), character(fromSample: sample1))
    }

    func testCharactersWithDifferentIdsAreNotEqual() {
        XCTAssertNotEqual(character(fromSample: sample1), character(fromSample: sample2))
    }
}
