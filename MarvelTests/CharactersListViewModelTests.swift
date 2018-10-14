//
//  CharactersListViewModelTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import RxCocoaNetworking
import RxSwift
import RxTest
import XCTest
@testable import Marvel

enum SomeError: Error {
    case error
}

class CharactersListViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    let initialTime = 0

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)
    }

    func testCharactersStartsEmptyThenLoads() {
        let delay = 10
        let service = MarvelService(stubBehavior: .delayed(time: TimeInterval(delay), stub: .default),
                                    scheduler: scheduler)
        let sut = CharactersListViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.characters()
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            next(initialTime + delay, 20),
            completed(initialTime + delay) // it completes because currently there's no reload/pagination
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testCharactersDoesNotErrorOutIfServiceResponseFails() {
        let service = MarvelService(stubBehavior: .immediate(stub: .error(SomeError.error)),
                                    scheduler: scheduler)
        let sut = CharactersListViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.characters()
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            completed(initialTime) // it completes because currently there's no reload/pagination
        ]
        XCTAssertEqual(results.events, expected)
    }
}