//
//  ShowsListViewMode.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import Combine
import SwiftUI

protocol ShowsListViewModelType: ObservableObject {
    var state: LoadableState<[Show]> { get }
    var isLoadingBottom: Bool { get }

    var searchQuery: String { get set }
    var searchState: LoadableState<[Show]> { get }

    func onAppear() async
    func reachedBottom()
    func tapShow(_ show: Show)
}


final class ShowsListViewModel: ShowsListViewModelType, ObservableObject {
    private let service: ShowsServiceType
    private var currentPage = 1
    private var allShows: [Show] = []
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    private let router: any ShowsListRouterType

    @Published var searchQuery: String = ""
    @Published var searchState: LoadableState<[Show]> = .success([])

    @Published var state: LoadableState<[Show]> = .idle
    @Published var isLoadingBottom: Bool = false

    init(router: any ShowsListRouterType,
         service: ShowsServiceType = ShowsService()) {
        self.service = service
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
        state = .loading
        await request(page: currentPage)
    }

    func reachedBottom() {
        guard !isLoadingBottom, canLoadMore else { return }

        isLoadingBottom = true
        currentPage += 1

        Task {
            await request(page: currentPage)
        }
    }

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

        let result = await service.searchShows(for: query)

        switch result {
            case .success(let results):
            searchState = .success(results.map(\.show))
        case .failure(let error):
            searchState = .failure(error)
        }
    }

    @MainActor
    private func request(page: Int) async {
        let result = await service.getShows(for: page)

        switch result {
        case .success(let shows):
            let newShows = shows.filter { new in
                !allShows.contains(where: { $0.id == new.id })
            }

            allShows.append(contentsOf: newShows)
            state = .success(allShows)
            isLoadingBottom = false

        case .failure(let error):
            isLoadingBottom = false
            if allShows.isEmpty {
                state = .failure(error)
            }

            if case let .statusCode(code, _) = error, code == 404 {
                canLoadMore = false // TODO: Prevent refreshes
            }
        }
    }
}
