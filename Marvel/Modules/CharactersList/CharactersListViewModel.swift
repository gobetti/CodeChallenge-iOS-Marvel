//
//  CharactersListViewModel.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import RxCocoa
import RxSwift

struct CharactersListViewModel {
    private let service: MarvelService

    init(service: MarvelService = MarvelService()) {
        self.service = service
    }

    func characters(pageRequester: Observable<Void>) -> Driver<[Character]> {
        var offset = 0

        return pageRequester.startWith(())
            .flatMapFirst { _ in
                self.service.characters(offset: offset)
                    .do(onSuccess: { offset += $0.count })
                    .catchError { _ in Single.just([]) }
            }
            .scan([Character]()) { accumulatedCharacters, newCharacters -> [Character] in
                accumulatedCharacters + newCharacters
            }
            .startWith([])
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
    }
}
