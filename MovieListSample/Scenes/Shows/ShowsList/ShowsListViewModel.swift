//
//  ShowsListViewMode.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

protocol ShowsListViewModelType: ObservableObject {
    var state: LoadableState<[Show]> { get }
    var isLoadingBottom: Bool { get }

    func onAppear() async
    func reachedBottom()
}


final class ShowsListViewModel: ShowsListViewModelType, ObservableObject {
    private let service: ShowsServiceType
    private var currentPage = 1
    private var allShows: [Show] = []
    private var canLoadMore = true

    @Published var state: LoadableState<[Show]> = .idle
    @Published var isLoadingBottom: Bool = false

    init(service: ShowsServiceType = ShowsService()) {
        self.service = service
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

    @MainActor
    private func request(page: Int) async {
        let result = await service.getShows(for: page)

        switch result {
        case .success(let shows):
            let newShows = shows.filter { new in
                !allShows.contains(where: { $0.id == new.id })
            }

            canLoadMore = !newShows.isEmpty
            allShows.append(contentsOf: newShows)
            state = .success(allShows)
            isLoadingBottom = false

        case .failure(let error):
            isLoadingBottom = false
            if allShows.isEmpty {
                state = .failure(error)
            }
        }
    }
}
