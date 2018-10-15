//
//  CharacterDetailsViewModel.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import Foundation
import RxCocoa
import RxSwift

struct CharacterDetailsViewModel {
    private let service: MarvelService

    init(service: MarvelService = MarvelService()) {
        self.service = service
    }

    func comics(from character: Character) -> Driver<[Comic]> {
        let comics = character.comics
            .flatMap { $0.items }
            .flatMap {
                $0.compactMap { $0.resourceURI }
            }.flatMap {
                $0.map {
                    service.comic(resourceURI: $0)
                }
            }

        guard let validComics = comics else {
            return Driver.just([])
        }

        return Observable.from(validComics)
            .concat() // downloads serially
            .map { [$0] }
            .catchErrorJustReturn([])
            .scan([Comic]()) { accumulatedComics, newComics -> [Comic] in
                accumulatedComics + newComics
            }
            .startWith([])
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
    }
}
