//
//  FavoritesListViewModel.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import Combine
import SwiftUI

final class FavoritesListViewModel: ShowsListViewModelType, ObservableObject {
    private var allShows: [Show] = []
    private var cancellables = Set<AnyCancellable>()
    private let router: any ShowsListRouterType
    var title: String = "Favorite Shows"

    @Published var searchQuery: String = ""
    @Published var searchState: LoadableState<[Show]> = .success([])

    @Published var state: LoadableState<[Show]> = .idle
    @Published var isLoadingBottom: Bool = false

    init(router: any ShowsListRouterType) {
        self.router = router

        $searchQuery
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task { await self.searchShows(query: query) }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func onAppear() async {
        guard case .idle = state else { return }
        // TODO: FETCH FROM CORE DATA
    }

    func reachedBottom() {} // ignoring cause we don't want to do anything here

    func tapShow(_ show: Show) {
        router.route(to: .showDetail(ShowDetailData(from: show)))
    }

    @MainActor
    private func searchShows(query: String) async {
        guard !query.isEmpty else {
            searchState = .success([])
            return
        }
        
        searchState = .loading

        // TODO: FETCH FROM CORE DATA
    }
}
