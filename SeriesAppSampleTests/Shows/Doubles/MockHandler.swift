//
//  MockHandler.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import XCTest
@testable import SeriesAppSample

final class MockHandler: NetworkHandlerType {
    
    var responses: [String: Any] = [:]
    var executedPaths: [String] = []
    func execute<Response>(_ request: NetworkRequest) async -> Result<Response, NetworkError> where Response : Decodable {
        executedPaths.append(request.path)

        if let response = responses[request.path] as? Response {
            return .success(response)
        } else {
            return .failure(.statusCode(404, data: nil))
        }
    }
}
