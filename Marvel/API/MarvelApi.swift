//
//  MarvelApi.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import Foundation
import RxCocoaNetworking

enum MarvelApi {
    case characters

    static let apiKey = "<REPLACE ME>"
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
        let defaultParameters = ["apikey": MarvelApi.apiKey]

        switch self {
        case .characters:
            return Task(parameters: defaultParameters)
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
