//
//  CharactersListViewModelSpec.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Quick
import Nimble
import RxCocoaNetworking
import RxNimble
import RxSwift
import RxTest
@testable import Marvel

enum SomeError: Error {
    case error
}

class CharactersListViewModelSpec: QuickSpec {
    override func spec() {
        describe("Characters") {
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
                let sut = CharactersListViewModel(service: service)
                
                expect(sut.characters(pageRequester: .never()).map { $0.count }.asObservable())
                    .events(scheduler: scheduler, disposeBag: disposeBag)
                    .to(equal([
                        Recorded.next(initialTime, 0),
                        Recorded.next(initialTime + delay, 20)
                        ]))
            }
            
            it("does not error out if service response fails") {
                let service = MarvelService(stubBehavior: .immediate(stub: .error(SomeError.error)),
                                            scheduler: scheduler)
                let sut = CharactersListViewModel(service: service)
                
                expect(sut.characters(pageRequester: .never()).map { $0.count }.asObservable())
                    .events(scheduler: scheduler, disposeBag: disposeBag)
                    .to(equal([
                        Recorded.next(initialTime, 0)
                        ]))
            }
            
            it("appends second page when user paginates") {
                let paginationTime = 100
                let pageRequester = scheduler.createHotObservable([
                    next(paginationTime, ())
                    ])
                
                let service = MarvelService(stubBehavior: .immediate(stub: .default),
                                            scheduler: scheduler)
                let sut = CharactersListViewModel(service: service)
                
                expect(sut.characters(pageRequester: pageRequester.asObservable()).map { $0.count }.asObservable())
                    .events(scheduler: scheduler, disposeBag: disposeBag)
                    .to(equal([
                        Recorded.next(initialTime, 0),
                        Recorded.next(initialTime, 20),
                        Recorded.next(paginationTime, 40)
                        ]))
            }
            
            it("returns a single page for quick multiple pagination requests") {
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
                
                expect(sut.characters(pageRequester: pageRequester.asObservable()).map { $0.count }.asObservable())
                    .events(scheduler: scheduler, disposeBag: disposeBag)
                    .to(equal([
                        Recorded.next(initialTime, 0),
                        Recorded.next(initialTime + delay, 20),
                        Recorded.next(paginationTime + delay, 40)
                        ]))
            }
        }
    }
}
