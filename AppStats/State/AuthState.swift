//
//  AuthState.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 08/02/2024.
//

import Foundation

enum AuthStateErrorEnum: Error {
    case apiKeyError
    case apiKeyEmpty
    case vendorNumberEmpty
    case keyIdEmpty
    case issuerIdEmpty
    case unknown
}

enum AuthStateEnum {
    case error(error: AuthStateErrorEnum)
    case success
    case notInitialized
}

final class AuthState: ObservableObject {
    @Published private(set) var state: AuthStateEnum = .notInitialized
    @Published var authService: AuthService?
    
    init() {
        do {
            self.authService = try createAuthService()
            self.state = .success
        } catch {
            self.state = .error(error: error as! AuthStateErrorEnum)
        }
    }
    
    func createAuthService() -> {
        let apiKey = getFileImportState(fromValue: keychainService.loadSecretValue(forKey: kKeychainAPIKey))
        let vendorNumber = keychainService.loadSecretValue(forKey: kKeychainVendorNumber)
        let keyId = keychainService.loadSecretValue(forKey: kKeychainKeyId)
        let issuerId = keychainService.loadSecretValue(forKey: kKeychainIssuerId)
        
        guard let vn = vendorNumber, !vn.isEmpty else {
            self.state = .error(error:AuthStateErrorEnum.vendorNumberEmpty)
            return
        }
        guard let ki = keyId, !ki.isEmpty else {
            throw AuthStateErrorEnum.keyIdEmpty
        }
        guard let ii = issuerId, !ii.isEmpty else {
            throw AuthStateErrorEnum.issuerIdEmpty
        }
        guard case let .success(ak) = apiKey else {
            if case .error = apiKey {
                throw AuthStateErrorEnum.apiKeyError
            }
            
            if case .empty = apiKey {
                throw AuthStateErrorEnum.apiKeyEmpty
            }
            
            throw AuthStateErrorEnum.unknown
        }
        
        print("APIKey       : \(ak)")
        print("Vendor number: \(vn)")
        print("KeyID        : \(ki)")
        print("IssuerID     : \(ii)")
        return AuthService(keyID: ki, vendorNumber: vn, issuerID: ii, apiKey: ak)

    }
}
