
import SwiftUI

enum AppTab: Hashable {
    case allShows
    case favorites

    var title: String {
        switch self {
        case .allShows: "All Shows"
        case .favorites: "Favorites"
        }
    }

    var icon: String {
        switch self {
        case .allShows: "tv"
        case .favorites: "bookmark"
        }
    }
}

protocol AppRouterType: ObservableObject {
    var isPresentingPIN: Bool { get set }
    func build(_ tab: AppTab) -> any View
    func buildPin() -> any View
}

class AppRouter: AppRouterType {
    @Published var isPresentingPIN: Bool = true

    @ViewBuilder
    func build(_ tab: AppTab) -> any View {
        switch tab {
        case .allShows:
            ShowsListCoordinatorView(router: ShowsListRouter())


        case .favorites:
            ShowsListCoordinatorView(router: FavoritesListRouter())
        }
    }

    func buildPin() -> any View {
        PINCoordinatorView(router: PINRouter()) { [weak self] in
            self?.isPresentingPIN = false
        }
    }
}

struct AppCoordinatorView<Router: AppRouterType>: View {
    @ObservedObject var router: Router

    var body: some View {
        Group {
            if !router.isPresentingPIN {
                TabView {
                    router.build(.allShows).erased
                        .tabItem {
                            Label(AppTab.allShows.title, systemImage: AppTab.allShows.icon)
                        }
                    
                    router.build(.favorites).erased
                        .tabItem {
                            Label(AppTab.favorites.title, systemImage: AppTab.favorites.icon)
                        }
                }
                .applyTabBarAppearance()
                .tint(.action)
                .transition(.opacity)
            } else {
                router.buildPin().erased
                    .transition(.opacity)
            }
        }
    }
}


@main
struct AppRootView: App {
    private let appRouter = AppRouter()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(router: appRouter)
        }
    }
}
