import Foundation

public struct NetworkConfiguration: Sendable {
    public let scheme: String
    public let host: String

    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
