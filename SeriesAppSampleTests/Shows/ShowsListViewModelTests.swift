
import XCTest
import SwiftUI

@testable import SeriesAppSample

final class ShowsListViewModelTests: XCTestCase {
    var sut: ShowsListViewModel!
    var service: MockShowsService!
    var router: MockShowsRouter!

    override func setUp() {
        super.setUp()
        service = MockShowsService()
        router = MockShowsRouter()
        sut = ShowsListViewModel(router: router, service: service)
    }

    func testOnAppear_WhenCalled_ThenLoadsInitialPage() async {
        await sut.onAppear()

        XCTAssertTrue(service.getShowsCalled)
        XCTAssertEqual(sut.state, .success([.mock]))
    }

    func testReachedBottom_WhenCalled_ThenLoadsNextPage() async {
        await sut.onAppear()
        sut.reachedBottom()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(sut.state, .success([.mock]))
        XCTAssertFalse(sut.isLoadingBottom)
    }

    func testSearchQuery_WhenChanged_ThenTriggersSearch() async {
        sut.searchQuery = "Test"
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(service.searchShowsCalledWith, "Test")
        XCTAssertEqual(sut.searchState, .success([.mock]))
    }

    func testTapShow_WhenCalled_ThenRoutesToDetail() {
        sut.tapShow(.mock)

        if case .showDetail(let detailData) = router.routedTo {
            XCTAssertEqual(detailData.id, Show.mock.id)
        } else {
            XCTFail("Expected to route to .showDetail")
        }
    }
}
