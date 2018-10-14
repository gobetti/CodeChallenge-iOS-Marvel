//
//  MarvelModels.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML, etag: String?
    let data: CharacterDataContainer?

    static let decoder: JSONDecoder = {
        $0.dateDecodingStrategy = .formatted(Character.dateFormatter)
        return $0
    }(JSONDecoder())
}

struct CharacterDataContainer: Codable {
    let offset, limit, total, count: Int?
    let results: [Character]?
}

struct Character: Codable, Equatable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: Date?
    let thumbnail: Image?
    let resourceURI: String?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?
    let urls: [MarvelURL]?

    static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return $0
    }(DateFormatter())

    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}

struct ComicSummary: Codable {
    let resourceURI: String?
    let name: String?
}

struct StoryList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummary]?
}

struct StorySummary: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

struct EventList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [EventSummary]?
}

struct EventSummary: Codable {
    let resourceURI: String?
    let name: String?
}

struct SeriesList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummary]?
}

struct SeriesSummary: Codable {
    let resourceURI: String?
    let name: String?
}

struct Image: Codable {
    let path: String?
    let `extension`: ImageExtension?
}

enum ImageExtension: String, Codable {
    case gif
    case jpg
    case png
}

struct MarvelURL: Codable {
    let type: MarvelURLType?
    let url: String?
}

enum MarvelURLType: String, Codable {
    case comicLink = "comiclink"
    case detail
    case wiki
}
