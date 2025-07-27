//
//  PINStorage.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import Foundation
import Security

enum PINStorage {
    private static let service = "com.adauto.SeriesAppSample"
    private static let account = "user_pin"

    static var hasPin: Bool {
        return loadPin() != nil
    }

    static func savePin(_ pin: String) {
        deletePin() // Remove caso já exista

        guard let data = pin.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    static func validate(pin: String) -> Bool {
        return pin == loadPin()
    }

    static func deletePin() {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account
        ]

        SecItemDelete(query as CFDictionary)
    }

    private static func loadPin() -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne
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
