
import XCTest
import CoreData
@testable import SeriesAppSample

final class FavoritesListViewModelTests: XCTestCase {
    var sut: FavoritesListViewModel!
    var router: MockShowsRouter!
    var service: MockFavoritesService!
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        router = MockShowsRouter()
        service = MockFavoritesService()
        container = PersistenceController(inMemory: true).container
    }

    func testOnAppear_WhenCalled_ThenLoadsFavorites() async {
        let context = container.viewContext

        let fav = FavoriteShow(context: context)
        fav.id = 1
        try? context.save()

        service.showsById[1] = .mock()

        sut = FavoritesListViewModel(router: router, service: service, container: container)

        await sut.onAppear()

        XCTAssertEqual(sut.state, .success([.mock()]))
    }

    func testTapShow_WhenCalled_ThenRoutesToDetail() {
        sut = FavoritesListViewModel(router: router, service: service, container: container)

        sut.tapShow(.mock())

        if case .showDetail(let detailData) = router.routedTo {
            XCTAssertEqual(detailData.id, Show.mock().id)
        } else {
            XCTFail("Expected to route to .showDetail")
        }
    }

    func testSearchQuery_WhenSet_ThenFiltersCorrectly() async {
        let context = container.viewContext

        let fav1 = FavoriteShow(context: context); fav1.id = 1
        let fav2 = FavoriteShow(context: context); fav2.id = 2
        try? context.save()

        service.showsById[1] = Show.mock()
        service.showsById[2] = Show.mock(id: 2, name: "Another Show")
        sut = FavoritesListViewModel(router: router, service: service, container: container)

        await sut.onAppear()

        sut.searchQuery = "Another"
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(sut.searchState, .success([service.showsById[2]!]))
    }
}
