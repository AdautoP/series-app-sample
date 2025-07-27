
import XCTest
@testable import SeriesAppSample

final class ShowsServiceTests: XCTestCase {
    var sut: ShowsService!
    var handler: MockHandler!

    override func setUp() {
        super.setUp()
        handler = MockHandler()
        sut = ShowsService(handler: handler)
    }

    func testGetShows_WhenCalledWithPage_ThenReturnsShows() async {
        handler.responses["/shows"] = [Show.mock]

        let result = await sut.getShows(for: 1)

        switch result {
        case .success(let shows):
            XCTAssertEqual(shows, [Show.mock])
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testGetEpisodes_WhenCalledWithId_ThenReturnsEpisodes() async {
        let episode = Episode(id: 1, url: .init(string: "https://e.com")!, name: "Ep", season: 1, number: 1, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)
        handler.responses["/shows/123/episodes"] = [episode]

        let result = await sut.getEpisodes(for: 123)

        switch result {
        case .success(let episodes):
            XCTAssertEqual(episodes, [episode])
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testSearchShows_WhenCalledWithQuery_ThenReturnsSearchResults() async {
        let resultObj = SearchResult(score: 1.0, show: .mock)
        handler.responses["/search/shows"] = [resultObj]

        let result = await sut.searchShows(for: "query")

        switch result {
        case .success(let results):
            XCTAssertEqual(results, [resultObj])
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testGetShowsFromIds_WhenAllFound_ThenReturnsSortedShows() async {
        let showA = Show.mock
        let showB = Show(
            id: 2,
            url: "",
            name: "Zeta Show",
            type: "",
            language: "",
            genres: [],
            status: "",
            runtime: nil,
            averageRuntime: nil,
            premiered: nil,
            ended: nil,
            officialSite: nil,
            schedule: .init(time: "", days: []),
            rating: .init(average: nil),
            weight: 0,
            network: nil,
            webChannel: nil,
            dvdCountry: nil,
            externals: .init(tvrage: nil, thetvdb: nil, imdb: nil),
            image: nil,
            summary: nil,
            updated: 0,
            links: .init(self: .init(href: ""), previousepisode: nil)
        )

        handler.responses["/shows/1"] = showA
        handler.responses["/shows/2"] = showB

        let result = await sut.getShows(from: [1, 2])

        switch result {
        case .success(let shows):
            XCTAssertEqual(shows.map(\.id), [1, 2])
        case .failure:
            XCTFail("Expected success")
        }
    }

    func testGetShowsFromIds_WhenEmptyIds_ThenReturnsEmptyList() async {
        let result = await sut.getShows(from: [])

        switch result {
        case .success(let shows):
            XCTAssertEqual(shows, [])
        case .failure:
            XCTFail("Expected empty success")
        }
    }

    func testGetShowsFromIds_WhenNoneFound_ThenReturnsFailure() async {
        let result = await sut.getShows(from: [999])

        switch result {
        case .success:
            XCTFail("Expected failure")
        case .failure(let error):
            if case .statusCode(let code, _) = error {
                XCTAssertEqual(code, 404)
            } else {
                XCTFail("Expected statusCode 404")
            }
        }
    }
}
