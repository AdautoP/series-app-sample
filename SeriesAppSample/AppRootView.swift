
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
        case .favorites: "heart"
        }
    }
}

struct AppCoordinatorView: View {
    @StateObject private var showsRouter = ShowsListRouter()
    @StateObject private var favoritesRouter = FavoritesListRouter()

    var body: some View {
        TabView {
            ShowsListCoordinatorView(router: showsRouter)
                .tabItem {
                    Label(AppTab.allShows.title, systemImage: AppTab.allShows.icon)
                }

            ShowsListCoordinatorView(router: favoritesRouter)
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
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
        }
    }
}
