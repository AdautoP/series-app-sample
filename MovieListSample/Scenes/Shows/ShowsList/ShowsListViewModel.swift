//
//  ShowsListViewMode.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

protocol ShowsListViewModelType: ObservableObject {
    var state: LoadableState<[Show]> { get }

    func onAppear() async
}

final class ShowsListViewModel: ShowsListViewModelType, ObservableObject {
    private let service: ShowsServiceType
    private var currentPage = 1

    @Published var state: LoadableState<[Show]> = .idle

    func onAppear() async {
        state = .loading
        let result = await service.getShows(for: currentPage)
        switch result {
        case .success(let shows):
            state = .success(shows)
        case .failure(let error):
            state = .failure(error)
        }
    }

    init(service: ShowsServiceType = ShowsService()) {
        self.service = service
    }
}
