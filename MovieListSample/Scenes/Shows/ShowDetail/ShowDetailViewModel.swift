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
        self.imageURL = show.image?.original ?? show.image?.medium
        self.scheduleText = {
            let days = show.schedule.days.joined(separator: ", ")
            return days.isEmpty ? "No schedule info" : "\(days) at \(show.schedule.time)"
        }()
        self.genresText = show.genres.isEmpty ? "No genres" : show.genres.joined(separator: ", ")
        self.summary = {
            guard let summaryHTML = show.summary,
                  let data = summaryHTML.data(using: .utf8),
                  let nsAttr = try? NSAttributedString(
                      data: data,
                      options: [
                          .documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue
                      ],
                      documentAttributes: nil
                  ) else {
                return nil
            }

            return AttributedString(nsAttr.string)
        }()
    }
}

protocol ShowDetailViewModelType: ObservableObject {
    var data: ShowDetailData { get }
    var seasonsState: LoadableState<[Season]> { get }

    func onAppear() async
}

final class ShowDetailViewModel: ShowDetailViewModelType {
    private(set) var data: ShowDetailData
    private let service: ShowsServiceType

    @Published var seasonsState: LoadableState<[Season]> = .idle

    init(show: ShowDetailData, service: ShowsServiceType = ShowsService()) {
        self.data = show
        self.service = service
    }

    @MainActor
    func onAppear() async {
        seasonsState = .loading

        let result = await service.getEpisodes(for: data.id)

        switch result {
        case .success(let episodes):
            let grouped = Dictionary(grouping: episodes, by: \.season)
            let sorted = grouped
                .sorted(by: { $0.key < $1.key })
                .map { key, episodes in
                    Season(name: "Season \(key)", episodes: episodes.sorted(by: { $0.number < $1.number }))
                }
            seasonsState = .success(sorted)
        case  .failure(let error):
            seasonsState = .failure(error)
        }
    }
}
