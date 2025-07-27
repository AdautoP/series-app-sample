//
//  MockShowsRouter.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import XCTest
import SwiftUI
@testable import SeriesAppSample

final class MockShowsRouter: ShowsListRouterType {
    var path = NavigationPath()
    var sheet: ShowsListRoute?
    var fullScreen: ShowsListRoute?
    var routedTo: ShowsListRoute?
    
    func route(to route: ShowsListRoute) {
        routedTo = route
    }
    
    func build(for route: ShowsListRoute) -> any View {
        EmptyView()
    }
}
