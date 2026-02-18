//
//  NetworkRequest.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int, data: Data?)
    case decoding(Error)
}

public struct NetworkRequest {
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]?
    public let queryItems: [URLQueryItem]?
    public let body: [String: Any]?

    public init(
        path: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        body: [String: Any]? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}


