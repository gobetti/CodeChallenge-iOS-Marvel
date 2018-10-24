//
//  MarvelApiTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import Quick
import Nimble
import RxCocoaNetworking
import RxNimble
import RxSwift
import RxTest
@testable import Marvel

extension MarvelApi: TargetType {
    public var sampleData: Data {
        switch self {
        case .characters(let offset):
            let jsonFileName: String
            if offset == 0 {
                jsonFileName = "characters_sample"
            } else {
                jsonFileName = "characters_offset20_sample"
            }

            let jsonFileURL = urlForJsonFile(name: jsonFileName)
            return try! Data(contentsOf: jsonFileURL)
        case .comic:
            let jsonFileURL = urlForJsonFile(name: "comic_sample")
            return try! Data(contentsOf: jsonFileURL)
        }
    }

    private func urlForJsonFile(name: String) -> URL {
        let bundle = Bundle(for: MarvelApiSpec.self)
        return bundle.url(forResource: name, withExtension: "json")!
    }
}

class MarvelApiSpec: QuickSpec {
override func spec() {
describe("Characters") {
    let initialTime = 0
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    beforeEach {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)
    }

    it("decodes successfully") {
        let service = MarvelService(stubBehavior: .immediate(stub: .default), scheduler: scheduler)

        expect(service.characters().map { $0.count }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(initialTime, 20),
                Recorded.completed(initialTime)
                ]))
    }

    it("is empty when wrapper misses data") {
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

        expect(service.characters().map { $0.count }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(initialTime, 00),
                Recorded.completed(initialTime)
                ]))
    }
}

describe("Comic") {
    let initialTime = 0
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    beforeEach {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)
    }

    it("errors out when wrapper has no results") {
        let jsonData = """
        {
            "data": {
                "results": []
            }
        }
        """.data(using: .utf8)!
        let service = MarvelService(stubBehavior: .immediate(stub: .success(jsonData)),
                                    scheduler: scheduler)

        expect(service.comic(resourceURI: "").map { $0.id! }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.error(initialTime, MarvelServiceError.noComic)
                ]))
    }
}
}
}
