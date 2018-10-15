//
//  CharacterDetailsViewModelTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import RxCocoaNetworking
import RxSwift
import RxTest
import XCTest
@testable import Marvel

class CharacterDetailsViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var character: Marvel.Character!
    let initialTime = 0

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)

        let comicSummary = ComicSummary(resourceURI: "foo")
        let comicList = ComicList(items: [comicSummary])
        character = Character(id: 1, name: nil, comics: comicList)
    }

    func testComicsStartsEmptyThenLoads() {
        let delay = 10
        let service = MarvelService(stubBehavior: .delayed(time: TimeInterval(delay), stub: .default),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.comics(from: self.character)
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            next(initialTime + delay, character.comics!.items!.count),
            completed(initialTime + delay)
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testComicsDoesNotErrorOutIfServiceResponseFails() {
        let service = MarvelService(stubBehavior: .immediate(stub: .error(SomeError.error)),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.comics(from: self.character)
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            completed(initialTime)
        ]
        XCTAssertEqual(results.events, expected)
    }

    func testComicsDoesNotErrorOutIfCharacterHasNoComics() {
        let service = MarvelService(stubBehavior: .immediate(stub: .default),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        let emptyCharacter = Character(id: 1, name: nil, comics: nil)

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(0) {
            sut.comics(from: emptyCharacter)
                .map { $0.count }
                .drive(results)
                .disposed(by: self.disposeBag)
        }
        scheduler.start()

        let expected = [
            next(initialTime, 0),
            completed(initialTime)
        ]
        XCTAssertEqual(results.events, expected)
    }
}
