//
//  ContentView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 25/07/25.
//

import SwiftUI

struct ShowsListView<ViewModel: ShowsListViewModelType>: View {

    @FocusState var searchFieldFocused: Bool
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            SearchBarView(text: $viewModel.searchQuery,
                          isFocused: $searchFieldFocused) {
                searchFieldFocused = false
            }
            .padding(.horizontal)

            mainList
                .overlay {
                    if searchFieldFocused {
                        searchResultsList
                    }
                }
        }
        .background(.backgroundPrimary)
        .onAppear {
            Task { await viewModel.onAppear() }
        }
    }

    private var mainList: some View {
        AsyncView(viewModel.state) { shows in
            VStack {
                List(shows) { show in
                    ShowRowView(show: show)
                        .onAppear {
                            if show == shows.last {
                                if !viewModel.isLoadingBottom {
                                    viewModel.reachedBottom()
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

                if viewModel.isLoadingBottom {
                    HStack {
                        Spacer()

                        ProgressView()
                            .padding(.vertical)
                            .tint(.action)

                        Spacer()
                    }
                    .fixedSize()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchResultsList: some View {
        AsyncView(viewModel.searchState, showLoadingOverlay: true) { shows in
            // TODO: Implement empty state if shows.isEmpty
            List(shows) { show in
                ShowRowView(show: show)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .zIndex(1)
        }
        .background(.backgroundPrimary)
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
    var searchQuery: String = ""

    var isLoadingBottom: Bool = false

    func reachedBottom() {}

    @Published var state: LoadableState<[Show]> = .success(mockShows)
    @Published var searchState: LoadableState<[Show]> = .success(mockShows)
    func onAppear() async {}
}

#Preview {
    ShowsListView(viewModel: MockVM())
}



