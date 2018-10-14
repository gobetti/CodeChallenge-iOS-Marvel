//
//  MarvelApi.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import Foundation
import RxCocoaNetworking

enum MarvelApi {
    case characters(offset: Int)
}

extension MarvelApi: ProductionTargetType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com:443")! // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        let pathSuffix: String

        switch self {
        case .characters:
            pathSuffix = "characters"
        }

        return "/v1/public/\(pathSuffix)"
    }

    var task: Task {
        let authParameters = MarvelApiAuthorization.parameters

        switch self {
        case .characters(let offset):
            let parameters = ["offset": "\(offset)"]
            return Task(parameters: authParameters.merging(parameters) { _, new in new })
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
