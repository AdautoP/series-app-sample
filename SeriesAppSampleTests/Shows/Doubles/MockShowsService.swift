//
//  MockShowsService.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import XCTest
@testable import SeriesAppSample

final class MockShowsService: ShowsServiceType {
    var getShowsCalled = false
    var showsResult: Result<[Show], NetworkError> = .success([.mock()])
    func getShows(for page: Int) async -> Result<[Show], NetworkError> {
        getShowsCalled = true
        return showsResult
    }


    var getEpisodesCalled = false
    var episodesResult: Result<[Episode], NetworkError> = .success([Episode(id: 1, url: .init(string: "https://e.com")!, name: "1", season: 1, number: 2, type: "", airdate: "", airtime: "", runtime: nil, rating: .init(average: nil), image: nil, summary: nil)])
    func getEpisodes(for showId: Int) async -> Result<[Episode], NetworkError> {
        getEpisodesCalled = true
        return episodesResult
    }

    var searchShowsCalledWith: String?
    var searchResult: Result<[SearchResult], NetworkError> = .success([SearchResult(score: 1.0, show: .mock())])
    func searchShows(for query: String) async -> Result<[SearchResult], NetworkError> {
        searchShowsCalledWith = query
        return searchResult
    }
}
