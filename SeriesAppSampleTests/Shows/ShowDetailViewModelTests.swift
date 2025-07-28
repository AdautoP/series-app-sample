
import XCTest
import CoreData
import SwiftUI
@testable import SeriesAppSample

final class ShowDetailViewModelTests: XCTestCase {

    var sut: ShowDetailViewModel!
    var router: MockShowsRouter!
    var service: MockShowsService!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        router = MockShowsRouter()
        service = MockShowsService()
        context = PersistenceController(inMemory: true).container.viewContext

        sut = ShowDetailViewModel(
            show: ShowDetailData(from: .mock()),
            router: router,
            service: service,
            coreDataContainer: PersistenceController(inMemory: true).container
        )
    }

    func testOnAppear_WhenCalled_ThenLoadsAndGroupsEpisodes() async {
        let ep1 = Episode(id: 1, url: .init(string: "https://e.com")!, name: "1", season: 1, number: 2, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)
        let ep2 = Episode(id: 2, url: .init(string: "https://e.com")!, name: "2", season: 1, number: 1, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)
        let ep3 = Episode(id: 3, url: .init(string: "https://e.com")!, name: "3", season: 2, number: 1, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)

        service.episodesResult = .success([ep1, ep2, ep3])
        await sut.onAppear()

        if case .success(let seasons) = sut.seasonsState {
            XCTAssertEqual(seasons.count, 2)
            XCTAssertEqual(seasons[0].episodes.map(\.id), [2, 1])
            XCTAssertEqual(seasons[1].episodes.map(\.id), [3])
        } else {
            XCTFail("Expected success state")
        }
    }

    func testToggleFavorite_WhenCalled_ThenChangesFavoriteState() {
        let initial = sut.isFavorite
        sut.toggleFavorite()
        let after = sut.isFavorite
        XCTAssertNotEqual(initial, after)
    }

    func testTapEpisode_WhenCalled_ThenRoutesToEpisodeDetail() {
        let episode = Episode(id: 7, url: .init(string: "https://e.com")!, name: "E", season: 1, number: 1, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)

        sut.tapEpisode(episode)

        if case .episodeDetail(let detail) = router.routedTo {
            XCTAssertEqual(detail.id, episode.id)
        } else {
            XCTFail("Expected routing to .episodeDetail")
        }
    }
}
