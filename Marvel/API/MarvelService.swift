//
//  MarvelService.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import RxCocoaNetworking
import RxSwift

struct MarvelService {
    private let provider: Provider<MarvelApi>

    init(stubBehavior: StubBehavior = .never,
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        provider = Provider(stubBehavior: stubBehavior, scheduler: scheduler)
    }

    func characters() -> Single<[Character]> {
        return provider.request(.characters)
            .mapToCharacterDataWrapper()
            .map { characterDataWrapper -> [Character] in
                guard let characters = characterDataWrapper.data?.results else { return [] }
                return characters
            }
    }
}

private extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Data {
    func mapToCharacterDataWrapper() -> Single<CharacterDataWrapper> {
        return map { data -> CharacterDataWrapper in
            let swiftType = CharacterDataWrapper.self
            let decoder = swiftType.decoder
            return try decoder.decode(swiftType, from: data)
        }
    }
}
