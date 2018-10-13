//
//  MarvelApiTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import RxCocoaNetworking
import RxSwift
import RxTest
import XCTest
@testable import Marvel

extension MarvelApi: TargetType {
    public var sampleData: Data {
        let bundle = Bundle(for: MarvelApiTests.self)

        switch self {
        case .characters:
            let jsonFileURL = bundle.url(forResource: "characters_sample", withExtension: "json")!
            return try! Data(contentsOf: jsonFileURL)
        }
    }
}

class MarvelApiTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    let initialTime = 0

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
    }

    func testCharactersDecodingSucceeds() {
        let provider = Provider<MarvelApi>(stubBehavior: .immediate(stub: .default))
        
        let results = scheduler.createObserver(Int.self)
        
        scheduler.scheduleAt(initialTime) {
            provider.request(.characters)
                .map { jsonData -> CharacterDataWrapper in
                    let swiftType = CharacterDataWrapper.self
                    let decoder = swiftType.decoder
                    return try! decoder.decode(swiftType, from: jsonData)
                }
                .map { $0.data!.results!.count }
                .asObservable()
                .subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 20),
            completed(initialTime)
        ]

        XCTAssertEqual(results.events, expected)
    }
}
