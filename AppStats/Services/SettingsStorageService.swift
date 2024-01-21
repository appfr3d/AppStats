//
//  SettingsStorageService.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 20/12/2023.
//

import Foundation

class KeychainService {

    // MARK: - Properties

    private let service: String

    // MARK: - Initialization

    init(service: String) {
        self.service = service
    }

    // MARK: - Keychain Access

    func saveSecretValue(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            print("KeychainService: cannot convert value (\(value) to data")
            return false
        }
        
        // Create the keychain query
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Check if the item already exists
        if let _ = loadSecretValue(forKey: key) {
            // If it exists, update the existing item
            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]

            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            
            return status == errSecSuccess
        } else {
            // If it doesn't exist, create a new item
            query[kSecValueData as String] = data

            // Add access control to make the item accessible after first unlock
            let accessControl = SecAccessControlCreateWithFlags(
                nil,
                kSecAttrAccessibleAfterFirstUnlock,
                .privateKeyUsage,
                nil
            )

            query[kSecAttrAccessControl as String] = accessControl

            // Add the item to the keychain
            let status = SecItemAdd(query as CFDictionary, nil)
            
            return status == errSecSuccess
        }
    }

    func loadSecretValue(forKey key: String) -> String? {
        // Create the keychain query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func deleteSecretValue(forKey key: String) -> Bool {
        // Create the keychain query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        // Delete the item from the keychain
        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }
}
