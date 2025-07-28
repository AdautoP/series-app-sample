//
//  ShowDetailViewSnapshotTests.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 28/07/25.
//


import XCTest
import SnapshotTesting
import SwiftUI
@testable import SeriesAppSample

final class ShowDetailViewSnapshotTests: XCTestCase {

    func testShowDetailViewSnapshot() {
        let viewModel = MockShowDetailViewModel()
        let view = ShowDetailView(viewModel: viewModel)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13)),
            named: "ShowDetail_Default",
            record: false
        )
    }
}
