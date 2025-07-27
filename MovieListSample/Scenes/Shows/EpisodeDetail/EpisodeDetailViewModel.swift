//
//  EpisodeDetailViewModel.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

struct EpisodeDetailData: Hashable, Identifiable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: AttributedString?
    let imageURL: URL?
}

extension EpisodeDetailData {
    init(from episode: Episode) {
        self.id = episode.id
        self.name = episode.name
        self.season = episode.season
        self.number = episode.number
        self.imageURL = episode.image?.original ?? episode.image?.medium

        if let html = episode.summary,
           let data = html.data(using: .utf8),
           let nsAttr = try? NSAttributedString(
               data: data,
               options: [.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
               documentAttributes: nil) {
            self.summary = AttributedString(nsAttr.string)
        } else {
            self.summary = nil
        }
    }
}

protocol EpisodeDetailViewModelType: ObservableObject {
    var data: EpisodeDetailData { get }
}

final class EpisodeDetailViewModel: EpisodeDetailViewModelType {
    let data: EpisodeDetailData

    init(episode: EpisodeDetailData) {
        self.data = episode
    }
}
