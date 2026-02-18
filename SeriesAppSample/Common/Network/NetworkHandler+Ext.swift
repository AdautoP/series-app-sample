//
//  NetworkHandler+Ext.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 18/02/26.
//

import Network

extension NetworkHandler {
    static var shared: NetworkHandlerType {
        NetworkHandler(configuration: EnvironmentValues.networkConfig)
    }
}
