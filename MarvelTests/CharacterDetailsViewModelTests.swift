//
//  CharacterDetailsViewModelTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import Quick
import Nimble
import RxCocoaNetworking
import RxNimble
import RxSwift
import RxTest
@testable import Marvel

class CharacterDetailsViewModelSpec: QuickSpec {
override func spec() {
describe("Comics") {
    let comicSummary = ComicSummary(resourceURI: "foo")
    let comicList = ComicList(items: [comicSummary])
    let character = Character(id: 1, name: nil, comics: comicList)

    let initialTime = 0
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    beforeEach {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: initialTime, simulateProcessingDelay: false)
    }

    it("starts empty then loads") {
        let delay = 10
        let service = MarvelService(stubBehavior: .delayed(time: TimeInterval(delay), stub: .default),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        expect(sut.comics(from: character).map { $0.count }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(initialTime, 0),
                Recorded.next(initialTime + delay, character.comics!.items!.count),
                Recorded.completed(initialTime + delay)
                ]))
    }

    it("does not error out if service response fails") {
        let service = MarvelService(stubBehavior: .immediate(stub: .error(SomeError.error)),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        expect(sut.comics(from: character).map { $0.count }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(initialTime, 0),
                Recorded.completed(initialTime)
                ]))
    }

    it("does not error out if character has no comics") {
        let service = MarvelService(stubBehavior: .immediate(stub: .default),
                                    scheduler: scheduler)
        let sut = CharacterDetailsViewModel(service: service)

        let emptyCharacter = Character(id: 1, name: nil, comics: nil)

        expect(sut.comics(from: emptyCharacter).map { $0.count }.asObservable())
            .events(scheduler: scheduler, disposeBag: disposeBag)
            .to(equal([
                Recorded.next(initialTime, 0),
                Recorded.completed(initialTime)
                ]))
    }
}
}
}
