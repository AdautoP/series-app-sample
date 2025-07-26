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
    let image: ShowImage?
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

struct Rating: Codable, Equatable {
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

struct ShowImage: Codable, Equatable {
    let medium: String
    let original: String
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
