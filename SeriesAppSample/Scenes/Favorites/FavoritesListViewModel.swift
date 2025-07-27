//
//  FavoritesListViewModel.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import CoreData
import Combine
import SwiftUI

final class FavoritesListViewModel: ShowsListViewModelType, ObservableObject {
    private var allShows: [Show] = []
    private var cancellables = Set<AnyCancellable>()
    private let service: FavoritesServiceType
    private let router: any ShowsListRouterType
    private let container: NSPersistentContainer
    var title: String = "Favorite Shows"

    @Published var searchQuery: String = ""
    @Published var searchState: LoadableState<[Show]> = .success([])
    @Published var state: LoadableState<[Show]> = .idle
    @Published var isLoadingBottom: Bool = false

    init(router: any ShowsListRouterType,
         service: FavoritesServiceType = ShowsService(),
         container: NSPersistentContainer = PersistenceController.shared.container) {
        self.router = router
        self.service = service
        self.container = container

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
        state = .loading

        let favorites = FavoriteShow.fetchAll(context: container.viewContext).map(\.id)

        let result = await service.getShows(from: favorites.map { Int($0) })
        switch result {
        case .success(let shows):
            self.allShows = shows
            self.state = .success(shows)
        case .failure(let error):
            self.state = .failure(error)
        }
    }

    func reachedBottom() {} // No infinite scroll for favorites

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

        let filtered = allShows.filter {
            $0.name.lowercased().contains(query.lowercased())
        }

        searchState = .success(filtered)
    }
}
