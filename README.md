# 🎬 SeriesAppSample

A simple SwiftUI application that displays a list of TV shows, with the ability to search, view details, episodes per season, and manage favorites. Built with clean architecture and modular design.

## 🎥 App Demo

[📽️ Watch the demo](https://github.com/AdautoP/series-app-sample/raw/main/SeriesSampleAppDemo.mp4)


## 🧱 Architecture

The app follows a **modular MVVM + Coordinator + Router** architecture, promoting clear separation of concerns, reusability, and testability.

---

### 🔄 Data Flow Overview

- **View**: SwiftUI screen that observes the ViewModel.
- **ViewModel**: Contains presentation logic and observable state.
- **Service**: Handles all data-fetching (network or persistence).
- **Router**: Resolves navigation routes into Views.
- **Coordinator**: Owns navigation state and controls flow logic.

---

### ✅ View

The View is a `SwiftUI` structure that subscribes to state from the ViewModel and triggers user actions.

```swift
struct ShowsListView<ViewModel: ShowsListViewModelType>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        List {
            switch viewModel.state {
            case .success(let shows):
                ForEach(shows) { show in
                    Text(show.name)
                        .onTapGesture {
                            viewModel.tapShow(show)
                        }
                }
            case .loading:
                ProgressView()
            case .failure(let error):
                Text("Error: \(error.localizedDescription)")
            case .idle:
                EmptyView()
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}
```

---

### 🧠 ViewModel

The ViewModel owns business logic and application state, exposing data via `@Published` and handling actions from the View.

```swift
final class ShowsListViewModel: ShowsListViewModelType, ObservableObject {
    @Published var state: LoadableState<[Show]> = .idle
    private let service: ShowsServiceType
    private let router: ShowsListRouterType

    init(router: ShowsListRouterType, service: ShowsServiceType) {
        self.router = router
        self.service = service
    }

    @MainActor
    func onAppear() async {
        state = .loading
        let result = await service.getShows(for: 1)
        switch result {
        case .success(let shows):
            state = .success(shows)
        case .failure(let error):
            state = .failure(error)
        }
    }

    func tapShow(_ show: Show) {
        router.route(to: .showDetail(ShowDetailData(from: show)))
    }
}
```

---

### 🌐 Service

A Service abstracts data fetching from the network or persistence layer.

```swift
final class ShowsService: ShowsServiceType {
    private let handler: NetworkHandlerType

    init(handler: NetworkHandlerType = NetworkHandler.shared) {
        self.handler = handler
    }

    func getShows(for page: Int) async -> Result<[Show], NetworkError> {
        let request = NetworkRequest(path: "/shows", method: .get)
        return await handler.execute(request)
    }

    func searchShows(for query: String) async -> Result<[SearchResult], NetworkError> {
        let request = NetworkRequest(path: "/search/shows", method: .get, queryItems: [
            URLQueryItem(name: "q", value: query)
        ])
        return await handler.execute(request)
    }
}
```

---

### 🧭 Router

The Router translates route enums into real SwiftUI views and helps coordinate navigation.

```swift
final class ShowsListRouter: ShowsListRouterType, ObservableObject {
    @Published var path = NavigationPath()

    func route(to route: ShowsListRoute) {
        path.append(route)
    }

    @ViewBuilder
    func build(for route: ShowsListRoute) -> some View {
        switch route {
        case .list:
            ShowsListView(viewModel: ShowsListViewModel(router: self))
        case .showDetail(let data):
            ShowDetailView(viewModel: ShowDetailViewModel(show: data, router: self))
        }
    }
}
```

---

### 🧭 Coordinator

The Coordinator manages the navigation stack and decides which Router to use. It’s injected into the root of your app.

```swift
struct AppCoordinatorView<Router: AppRouterType>: View {
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            router.buildRoot()
                .navigationDestination(for: AppRoute.self) { route in
                    router.build(for: route)
                }
        }
    }
}
```

### Required Features
- Display All Shows
- Search All Shows by name
- Display Show Detail
- Display Episode Detail

### Optional Features
- Show Favorite shows
- Search Favorite shows by name
- Set PIN for accessing the app and use biometrics if available 

## 📦 Dependencies

This project uses:
- SwiftUI
- Combine
- CoreData
- XCTest for unit testing

## 🧪 Tests

All show related `ViewModel` and service are fully unit tested with mocked services and coordinators.

Example of test naming convention:
```swift
func testMethodName_WhenConditionHappens_ThenExpectResult()
````
