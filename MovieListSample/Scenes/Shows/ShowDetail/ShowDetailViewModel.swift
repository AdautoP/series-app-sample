//
//  ShowDetailViewModel.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

struct ShowDetailData: Hashable, Identifiable, Equatable {
    var id: Int
    var name: String
    var imageURL: URL?
    var scheduleText: String
    var genresText: String
    var summary: AttributedString?
}

extension ShowDetailData {
    init(from show: Show) {
        self.id = show.id
        self.name = show.name
        self.imageURL = URL(string: show.image?.original ?? show.image?.medium ?? "")
        self.scheduleText = {
            let days = show.schedule.days.joined(separator: ", ")
            return days.isEmpty ? "No schedule info" : "\(days) at \(show.schedule.time)"
        }()
        self.genresText = show.genres.isEmpty ? "No genres" : show.genres.joined(separator: ", ")
        self.summary = {
            guard let summaryHTML = show.summary else { return nil }
            return try? AttributedString(markdown: summaryHTML)
        }()
    }
}

protocol ShowDetailViewModelType: ObservableObject {
    var data: ShowDetailData { get }
}

final class ShowDetailViewModel: ShowDetailViewModelType {
    private(set) var data: ShowDetailData

    init(show: ShowDetailData) {
        self.data = show
    }
}
