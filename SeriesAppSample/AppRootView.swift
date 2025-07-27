
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
    func build(_ tab: AppTab) -> any View
}

class AppRouter: AppRouterType {
    @ViewBuilder
    func build(_ tab: AppTab) -> any View {
        switch tab {
        case .allShows:
            ShowsListCoordinatorView(router: ShowsListRouter())


        case .favorites:
            ShowsListCoordinatorView(router: FavoritesListRouter())
        }
    }
}

struct AppCoordinatorView<Router: AppRouterType>: View {

    @ObservedObject var router: Router

    var body: some View {
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
    }
}


@main
struct AppRootView: App {
    private let appRouter = AppRouter()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(router: appRouter)
                .task {
                    let model = PersistenceController.shared.container.managedObjectModel
                    print("Entities:", model.entities.map(\.name))
                }
        }
    }
}
