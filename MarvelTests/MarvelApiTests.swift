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
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)
    }

    func testCharactersDecodingSucceeds() {
        let service = MarvelService(stubBehavior: .immediate(stub: .default), scheduler: scheduler)
        
        let results = scheduler.createObserver(Int.self)
        
        scheduler.scheduleAt(initialTime) {
            service.characters()
                .map { $0.count }
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

    func testEmptyCharactersWhenWrapperMissesData() {
        let jsonData = """
        {
          "code": 200,
          "status": "Ok",
          "copyright": "© 2018 MARVEL",
          "attributionText": "Data provided by Marvel. © 2018 MARVEL",
          "attributionHTML": "",
          "etag": "ac7a21e8b0ec4f96cb58754d74f342706661b037"
        }
        """.data(using: .utf8)!
        let service = MarvelService(stubBehavior: .immediate(stub: .success(jsonData)), scheduler: scheduler)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(initialTime) {
            service.characters()
                .map { $0.count }
                .asObservable()
                .subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            completed(initialTime)
        ]

        XCTAssertEqual(results.events, expected)
    }
}
