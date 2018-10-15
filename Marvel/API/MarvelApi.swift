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
    case comic(resourceURI: String)
}

extension MarvelApi: ProductionTargetType {
    var baseURL: URL {
        switch self {
        case .characters:
            return URL(string: "https://gateway.marvel.com:443")! // swiftlint:disable:this force_unwrapping
        case .comic:
            return URL(string: "http://gateway.marvel.com")! // swiftlint:disable:this force_unwrapping
        }
    }

    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comic(let resourceURI):
            return String(resourceURI.dropFirst(baseURL.absoluteString.count))
        }
    }

    var task: Task {
        let authParameters = MarvelApiAuthorization.parameters

        switch self {
        case .characters(let offset):
            let parameters = ["offset": "\(offset)"]
            return Task(parameters: authParameters.merging(parameters) { _, new in new })
        case .comic:
            return Task(parameters: authParameters)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
