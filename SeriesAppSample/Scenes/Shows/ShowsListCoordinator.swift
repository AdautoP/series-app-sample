//
//  ShowsListCoordinator.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

enum ShowsListRoute: Hashable, Identifiable {
    var id: Int {
        switch self {
        case .list: return 0
        case .showDetail(let show): return show.id
        case .episodeDetail(let episode): return episode.id
        }
    }

    case list
    case showDetail(ShowDetailData)
    case episodeDetail(EpisodeDetailData)
}

protocol ShowsListRouterType: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: ShowsListRoute? { get set }
    var fullScreen: ShowsListRoute? { get set }

    func route(to route: ShowsListRoute)
    func build(for route: ShowsListRoute) -> any View
}


class ShowsListRouter: ShowsListRouterType, ObservableObject {
    @Published var path: NavigationPath = NavigationPath() {
        didSet {
            if path.isEmpty { showDetailViewModel = nil }
        }
    }
    
    @Published var sheet: ShowsListRoute?
    @Published var fullScreen: ShowsListRoute?

    private lazy var showsListViewModel: ShowsListViewModel =  {
        ShowsListViewModel(router: self)
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
            ShowsListView(viewModel: showsListViewModel)
        case .showDetail:
            if let showDetailViewModel {
                ShowDetailView(viewModel: showDetailViewModel)
            }
        case .episodeDetail(let episode):
            EpisodeDetailView(viewModel: EpisodeDetailViewModel(episode: episode))
        }
    }
}

struct ShowsListCoordinatorView<Router: ShowsListRouterType>: View {
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            router.build(for: .list).erased // erasing the root view
                .navigationDestination(for: ShowsListRoute.self) { route in
                    router.build(for: route).erased
                }
                .fullScreenCover(item: $router.fullScreen) { route in
                    router.build(for: route).erased
                }
                .sheet(item: $router.sheet) { route in
                    router.build(for: route).erased
                }
                .applyOpaqueNavigation()
        }
        .tint(.action)
    }
}
