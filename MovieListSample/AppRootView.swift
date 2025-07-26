
import SwiftUI

enum AppRoute: Hashable, Identifiable {
    var id: Int {
        switch self {
        case .home: return 0
        case .showDetail(let show): return show.id
        }
    }

    case home
    case showDetail(ShowDetailData)
}

protocol AppRouterType: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: AppRoute? { get set }
    var fullScreen: AppRoute? { get set }

    func route(to route: AppRoute)
    func build(for route: AppRoute) -> any View
}


class AppRouter: AppRouterType, ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: AppRoute?
    @Published var fullScreen: AppRoute?

    private lazy var showsListViewModel: ShowsListViewModel =  {
        ShowsListViewModel(router: self)
    }()

    func route(to route: AppRoute) {
        switch route {
        case .home:
            path.append(route)
        case .showDetail:
            path.append(route)
        }
    }

    @ViewBuilder
    func build(for route: AppRoute) -> any View {
        switch route {
        case .home:
            ShowsListView(viewModel: showsListViewModel)
        case .showDetail(let showData):
            ShowDetailView(viewModel: ShowDetailViewModel(show: showData))
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
