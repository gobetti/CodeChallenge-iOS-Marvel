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
            sut.characters(pageRequester: .never())
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            next(initialTime + delay, 20)
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testCharactersDoesNotErrorOutIfServiceResponseFails() {
        let service = MarvelService(stubBehavior: .immediate(stub: .error(SomeError.error)),
                                    scheduler: scheduler)
        let sut = CharactersListViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.characters(pageRequester: .never())
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0)
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testSecondPageIsAppendedWhenUserPaginates() {
        let paginationTime = 100
        let pageRequester = scheduler.createHotObservable([
            next(paginationTime, ())
            ])

        let service = MarvelService(stubBehavior: .immediate(stub: .default),
                                    scheduler: scheduler)
        let sut = CharactersListViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(initialTime) {
            sut.characters(pageRequester: pageRequester.asObservable())
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            next(initialTime, 20),
            next(paginationTime, 40)
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testSinglePageIsReturnedForQuickMultiplePaginationRequests() {
        let paginationTime = 100
        let paginationQuickRequestInterval = 1
        let pageRequester = scheduler.createHotObservable([
            next(paginationTime, ()),
            next(paginationTime + paginationQuickRequestInterval, ()),
            next(paginationTime + paginationQuickRequestInterval * 2, ()),
            next(paginationTime + paginationQuickRequestInterval * 3, ()),
            next(paginationTime + paginationQuickRequestInterval * 4, ())
            ])

        let delay = paginationQuickRequestInterval * 10
        let service = MarvelService(stubBehavior: .delayed(time: TimeInterval(delay), stub: .default),
                                    scheduler: scheduler)
        let sut = CharactersListViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(initialTime) {
            sut.characters(pageRequester: pageRequester.asObservable())
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            next(initialTime + delay, 20),
            next(paginationTime + delay, 40)
        ]
        XCTAssertEqual(results.events, expected)
    }
}
