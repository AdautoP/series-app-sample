//
//  ShowsListViewSnapshotTests.swift
//  SeriesAppSampleTests
//
//  Created by Adauto Pinheiro on 28/07/25.
//

import XCTest
import SnapshotTesting
@testable import SeriesAppSample

final class ShowsListViewTests: XCTestCase {
    func testShowsListViewSnapshot() {
        let viewModel = MockShowListViewModel()
        let view = ShowsListView(viewModel: viewModel)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13ProMax)),
            named: "Default_ShowsListView",
            record: false
        )
    }


    func testShowsListViewWhenSearchingSnapshot() {
        let viewModel = MockShowListViewModel()
        viewModel.searchQuery = "Game"
        let view = ShowsListView(viewModel: viewModel)
        
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13ProMax)),
            named: "Searching_ShowsListView",
            record: false
        )
    }
}

