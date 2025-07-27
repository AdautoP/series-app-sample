//
//  Episode.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import Foundation

// MARK: - Episode Model
struct Episode: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let url: URL
    let name: String
    let season: Int
    let number: Int
    let type: String
    let airdate: String
    let airtime: String
    let runtime: Int?
    let rating: Rating
    let image: APIImage?
    let summary: String?
}
