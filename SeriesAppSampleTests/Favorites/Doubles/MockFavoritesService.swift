//
//  MockFavoritesService.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import XCTest
import CoreData
@testable import SeriesAppSample

final class MockFavoritesService: FavoritesServiceType {
    
    var showsById: [Int: Show] = [:]
    func getShows(from ids: [Int]) async -> Result<[Show], NetworkError> {
        let found = ids.compactMap { showsById[$0] }
        return .success(found)
    }
}
