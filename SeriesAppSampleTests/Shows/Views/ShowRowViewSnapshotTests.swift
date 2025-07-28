//
//  ShowsListViewTests.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 28/07/25.
//


//
//  ShowsListViewSnapshotTests.swift
//  SeriesAppSampleTests
//
//  Created by Adauto Pinheiro on 28/07/25.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import SeriesAppSample

final class ShowRowViewSnapshotTests: XCTestCase {
    func testShowsListViewSnapshot() {
        let view = ZStack {
            Color.backgroundPrimary
            ShowRowView(show: .mock())
        }

        assertSnapshot(
            of: view,
            as: .image(layout: .fixed(width: 200, height: 80)),
            named: "Default_ShowsListView",
            record: false
        )
    }
}

