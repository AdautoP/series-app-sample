//
//  NetworkService.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import Foundation

protocol NetworkHandlerType {
    func execute<Response: Decodable>(
        _ request: NetworkRequest
    ) async -> Result<Response, NetworkError>
}


final class NetworkHandler: NetworkHandlerType {
    private let session: URLSession
    private let decoder: JSONDecoder

    static let shared = NetworkHandler()

    private init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func execute<Response: Decodable>(
        _ request: NetworkRequest
    ) async -> Result<Response, NetworkError> {
        var components = URLComponents()
        components.scheme = Environment.scheme
        components.host = Environment.baseURL
        components.path += request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            return .failure(.invalidURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return .failure(.requestFailed(error))
            }
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(.statusCode(httpResponse.statusCode, data: data))
            }

            let decoded = try decoder.decode(Response.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
