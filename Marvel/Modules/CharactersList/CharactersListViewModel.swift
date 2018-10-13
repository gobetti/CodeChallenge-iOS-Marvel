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

    func characters() -> Driver<[Character]> {
        return service.characters()
            .asObservable()
            .startWith([])
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
    }
}
