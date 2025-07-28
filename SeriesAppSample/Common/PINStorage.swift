//
//  PINStorage.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import Foundation
import Security

protocol PINStorageType {
    var hasPin: Bool { get }
    func save(pin: String)
    func validate(pin: String) -> Bool
}

final class PINStorage: PINStorageType {
    static let shared = PINStorage()

    private let service = "com.adauto.SeriesAppSample"
    private let account = "user_pin"

    var hasPin: Bool {
        loadPIN() != nil
    }

    func save(pin: String) {
        guard let data = pin.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)

        let attributes: [String: Any] = query.merging([
            kSecValueData as String: data
        ]) { $1 }

        SecItemAdd(attributes as CFDictionary, nil)
    }

    func validate(pin: String) -> Bool {
        return loadPIN() == pin
    }

    private func loadPIN() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let pin = String(data: data, encoding: .utf8) else {
            return nil
        }

        return pin
    }
}
