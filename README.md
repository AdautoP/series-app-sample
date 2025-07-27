# 🎬 SeriesAppSample

A simple SwiftUI application that displays a list of TV shows, with the ability to search, view details, episodes per season, and manage favorites. Built with clean architecture and modular design.

## 🎥 App Demo

[📽️ Watch the demo](https://github.com/AdautoP/series-app-sample/raw/main/SeriesSampleAppDemo.mp4)

## 🧱 Architecture

The app follows a layered and modular architecture:

### Layers
- **View Layer**: Built entirely with SwiftUI and uses `ObservableObject` + `@Published` state management.
- **ViewModel Layer**: Pure and testable. Handles business logic, state, and routing triggers.
- **Service Layer**: Abstracted protocols and implementations for fetching data from the API.
- **Routing Layer**: Coordinators built around `NavigationStack`, `fullScreenCover`, and `sheet`, managed via enums.

### Required Features
- Display All Shows
- Search All Shows by name
- Display Show Detail
- Display Episode Detail

### Optional Features
- Show Favorite shows
- Search Favorite shows by name
- Set PIN for accessing the app and use biometrics if available 

---

## 📦 Dependencies

This project uses:
- SwiftUI
- Combine
- CoreData
- XCTest for unit testing

---

## 🧪 Tests

All show related `ViewModel` and service are fully unit tested with mocked services and coordinators.

Example of test naming convention:
```swift
func testMethodName_WhenConditionHappens_ThenExpectResult()
````
