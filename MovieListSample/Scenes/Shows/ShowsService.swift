//
//  ShowsService.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

protocol ShowsServiceType {
    func getShows(for page: Int) async -> Result<[Show], NetworkError>
}

final class ShowsService: ShowsServiceType {
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
}
