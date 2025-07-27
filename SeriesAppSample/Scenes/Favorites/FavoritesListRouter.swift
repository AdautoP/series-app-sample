//
//  FavoritesListRouter.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

class FavoritesListRouter: ShowsListRouterType, ObservableObject {
    @Published var path: NavigationPath = NavigationPath() {
        didSet {
            if path.isEmpty { showDetailViewModel = nil }
        }
    }

    @Published var sheet: ShowsListRoute?
    @Published var fullScreen: ShowsListRoute?

    private lazy var favoritesListViewModel: FavoritesListViewModel =  {
        FavoritesListViewModel(router: self)
    }()

    private var showDetailViewModel: ShowDetailViewModel?

    func route(to route: ShowsListRoute) {
        switch route {
        case .list:
            path.append(route)
        case .showDetail(let showData):
            if showDetailViewModel?.data.id != showData.id {
                showDetailViewModel = ShowDetailViewModel(show: showData, router: self)
            }
            path.append(route)
        case .episodeDetail:
            sheet = route
        }
    }

    @ViewBuilder
    func build(for route: ShowsListRoute) -> any View {
        switch route {
        case .list:
            ShowsListView(viewModel: favoritesListViewModel)
        case .showDetail:
            if let showDetailViewModel {
                ShowDetailView(viewModel: showDetailViewModel)
            }
        case .episodeDetail(let episode):
            EpisodeDetailView(viewModel: EpisodeDetailViewModel(episode: episode))
        }
    }
}

