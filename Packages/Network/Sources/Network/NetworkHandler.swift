//
//  NetworkService.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import Foundation

public protocol NetworkHandlerType {
    func execute<Response: Decodable>(
        _ request: NetworkRequest
    ) async -> Result<Response, NetworkError>
}

public final class NetworkHandler: NetworkHandlerType {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let configuration: NetworkConfiguration

    public init(
        configuration: NetworkConfiguration,
        session: URLSession = .shared,
        decoder: JSONDecoder = .init()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func execute<Response: Decodable>(
        _ request: NetworkRequest
    ) async -> Result<Response, NetworkError> {
        var components = URLComponents()
        components.scheme = configuration.scheme
        components.host = configuration.host
        components.path = request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            return .failure(.invalidURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
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

            do {
                let decoded = try decoder.decode(Response.self, from: data)
                return .success(decoded)
            } catch {
                return .failure(.decoding(error))
            }
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
