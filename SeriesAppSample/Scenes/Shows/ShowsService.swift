//
//  ShowsService.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

protocol ShowsServiceType {
    func getShows(for page: Int) async -> Result<[Show], NetworkError>
    func getEpisodes(for showId: Int) async -> Result<[Episode], NetworkError>
    func searchShows(for query: String) async -> Result<[SearchResult], NetworkError>
}

protocol FavoritesServiceType {
    func getShows(from ids: [Int]) async -> Result<[Show], NetworkError>
}

final class ShowsService: ShowsServiceType, FavoritesServiceType {
    private let handler: NetworkHandlerType

    init(handler: NetworkHandlerType = NetworkHandler.shared) {
        self.handler = handler
    }

    func getShows(for page: Int = 1) async -> Result<[Show], NetworkError> {
        let request = NetworkRequest(path: "/shows",
                                     method: .get,
                                     queryItems: [.init(name: "page", value: "\(page)")])
        return await handler.execute(request)
    }

    func getEpisodes(for showId: Int) async -> Result<[Episode], NetworkError> {
        let request = NetworkRequest(path: "/shows/\(showId)/episodes",
                                     method: .get)
        return await handler.execute(request)
    }

    func searchShows(for query: String) async -> Result<[SearchResult], NetworkError> {
        let request = NetworkRequest(path: "/search/shows",
                                     method: .get,
                                     queryItems: [.init(name: "q", value: query)])
        return await handler.execute(request)
    }

    func getShows(from ids: [Int]) async -> Result<[Show], NetworkError> {
        guard ids.count > 0 else { return .success([]) }
        var shows: [Show] = []

        await withTaskGroup(of: Result<Show, NetworkError>.self) { group in
            for id in ids {
                group.addTask {
                    let request = NetworkRequest(path: "/shows/\(id)", method: .get)
                    return await self.handler.execute(request)
                }
            }

            for await result in group {
                if case let .success(show) = result {
                    shows.append(show)
                }
            }
        }

        if !shows.isEmpty {
            return .success(shows.sorted(by: { $0.name < $1.name }))
        } else {
            return .failure(.statusCode(404, data: nil))
        }
    }
}
