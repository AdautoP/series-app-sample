//
//  Show.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import Foundation

struct Show: Codable, Identifiable, Equatable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String
    let genres: [String]
    let status: String
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let network: Network?
    let webChannel: WebChannel?
    let dvdCountry: Country?
    let externals: Externals
    let image: APIImage?
    let summary: String?
    let updated: Int
    let links: ShowLinks

    private enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime
        case premiered, ended, officialSite, schedule, rating, weight, network, webChannel
        case dvdCountry, externals, image, summary, updated
        case links = "_links"
    }
}

struct Schedule: Codable, Equatable {
    let time: String
    let days: [String]
}

struct Rating: Codable, Equatable, Hashable {
    let average: Double?
}

struct Network: Codable, Equatable {
    let id: Int
    let name: String
    let country: Country
    let officialSite: String?
}

struct WebChannel: Codable, Equatable {
    let id: Int
    let name: String
    let country: Country?
    let officialSite: String?
}

struct Country: Codable, Equatable {
    let name: String
    let code: String
    let timezone: String
}

struct Externals: Codable, Equatable {
    let tvrage: Int?
    let thetvdb: Int?
    let imdb: String?
}

struct APIImage: Codable, Equatable, Hashable {
    let medium: URL
    let original: URL
}

struct ShowLinks: Codable, Equatable {
    let `self`: Link
    let previousepisode: EpisodeLink?

    struct Link: Codable, Equatable {
        let href: String
    }

    struct EpisodeLink: Codable, Equatable {
        let href: String
        let name: String?
    }
}

struct SearchResult: Codable {
    let score: Double
    let show: Show
}

extension Show {
    static let mock: Show = Show(
        id: 1,
        url: "",
        name: "Mock Show",
        type: "Scripted",
        language: "English",
        genres: ["Drama", "Comedy"],
        status: "Running",
        runtime: 30,
        averageRuntime: 30,
        premiered: "2020-01-01",
        ended: nil,
        officialSite: nil,
        schedule: .init(time: "20:00", days: ["Monday"]),
        rating: .init(average: 8.5),
        weight: 90,
        network: .init(id: 1, name: "Mock Network", country: .init(name: "US", code: "US", timezone: "America/New_York"), officialSite: nil),
        webChannel: nil,
        dvdCountry: nil,
        externals: .init(tvrage: nil, thetvdb: nil, imdb: nil),
        image: .init(medium: URL(string: "https://http://picsum.photos/200")!, original: URL(string: "https://http://picsum.photos/200")!),
        summary: "A show about mocks",
        updated: 0,
        links: .init(self: .init(href: ""), previousepisode: nil)
    )
}
