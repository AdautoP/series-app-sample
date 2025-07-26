//
//  ContentView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 25/07/25.
//

import SwiftUI

struct ShowsListView<ViewModel: ShowsListViewModelType>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        AsyncView(viewModel.state) { shows in
            List(shows) { show in
                ShowRowView(show: show)
            }
            .listStyle(.plain)
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
    }
}

let mockShows = [Show(
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
    image: .init(medium: "", original: ""),
    summary: "A show about mocks",
    updated: 0,
    links: .init(self: .init(href: ""), previousepisode: nil)
)]

class MockVM: ShowsListViewModelType {
    @Published var state: LoadableState<[Show]> = .success(mockShows)
    func onAppear() async {}
}

#Preview {
    ShowsListView(viewModel: MockVM())
}



