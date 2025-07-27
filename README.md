# 🎬 SeriesAppSample

A simple SwiftUI application that displays a list of TV shows, with the ability to search, view details, episodes per season, and manage favorites. Built with clean architecture and modular design.

## 📸 Demo

https://github.com/your-username/your-repo/assets/your-video-id

*(Replace the URL above with the actual GitHub video link or upload the video to GitHub and update this section.)*

---

## 🧱 Architecture

The app follows a layered and modular architecture:

### Layers
- **View Layer**: Built entirely with SwiftUI and uses `ObservableObject` + `@Published` state management.
- **ViewModel Layer**: Pure and testable. Handles business logic, state, and routing triggers.
- **Service Layer**: Abstracted protocols and implementations for fetching data from the API.
- **Routing Layer**: Coordinators built around `NavigationStack`, `fullScreenCover`, and `sheet`, managed via enums.

### Features
- Debounced search with separate state
- Lazy loading for pagination (except favorites)
- Modular view composition using protocols
- ViewModel-driven routing (e.g., `ShowsListRouterType`)
- Loadable state wrapper (`LoadableState<T>`) for consistent async handling
- Core Data support for storing favorite shows
- Unit tests with mocked dependencies

---

## 📦 Dependencies

This project uses:
- SwiftUI
- Combine
- CoreData (via `NSPersistentContainer`)
- XCTest for unit testing

---

## 🧪 Tests

Each `ViewModel` and service is fully unit tested with mocked services and coordinators.

Example of test naming convention:
```swift
func testMethodName_WhenConditionHappens_ThenExpectResult()
````