
import SwiftUI

@main
struct AppRootView: App {

    let router = ShowsListRouter()

    var body: some Scene {
        WindowGroup {
            ShowsListCoordinatorView(router: router)
        }
    }
}
