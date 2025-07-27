
import SwiftUI

enum AppRoute: Hashable, Identifiable {
    var id: Int {
        switch self {
        case .home: return 0
        case .showDetail(let show): return show.id
        case .episodeDetail(let episode): return episode.id
        }
    }

    case home
    case showDetail(ShowDetailData)
    case episodeDetail(EpisodeDetailData)
}

protocol AppRouterType: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: AppRoute? { get set }
    var fullScreen: AppRoute? { get set }

    func route(to route: AppRoute)
    func build(for route: AppRoute) -> any View
}


class AppRouter: AppRouterType, ObservableObject {
    @Published var path: NavigationPath = NavigationPath() {
        didSet {
            if path.isEmpty { showDetailViewModel = nil }
        }
    }
    
    @Published var sheet: AppRoute?
    @Published var fullScreen: AppRoute?

    private lazy var showsListViewModel: ShowsListViewModel =  {
        ShowsListViewModel(router: self)
    }()

    private var showDetailViewModel: ShowDetailViewModel?

    func route(to route: AppRoute) {
        switch route {
        case .home:
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
    func build(for route: AppRoute) -> any View {
        switch route {
        case .home:
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

struct AppCoordinatorView<Router: AppRouterType>: View {
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            router.build(for: .home).erased // erasing the root view
                .navigationDestination(for: AppRoute.self) { route in
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

@main
struct AppRootView: App {

    let router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(router: router)
        }
    }
}
