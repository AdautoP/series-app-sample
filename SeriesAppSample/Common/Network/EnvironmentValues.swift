//
//  Environment.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import Network
import Foundation

enum EnvironmentValues {
    static var host: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_ROOT_URL") as? String else {
            fatalError("API_ROOT_URL not set in Info.plist")
        }
        return url
    }

    static var scheme: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String else {
            fatalError("API_SCHEME not set in Info.plist")
        }
        return url
    }

    static var networkConfig: NetworkConfiguration {
        .init(scheme: scheme, host: host)
    }
}
