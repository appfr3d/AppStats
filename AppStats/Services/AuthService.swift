//
//  AuthService.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 28/11/2023.
//
import Foundation
import SwiftJWT

struct AppstoreConnectClaims: Claims {
    let iss: String
    let iat: Date
    let exp: Date
    let aud: String
}

class AuthService {
    let keyID: String
    let vendorNumber: String
    let issuerID: String
    let apiKey: String
    
    init(keyID: String, vendorNumber: String, issuerID: String, apiKey: String) {
        self.keyID = keyID
        self.vendorNumber = vendorNumber
        self.issuerID = issuerID
        self.apiKey = apiKey
    }
    
    func getSignedToken() throws -> String {
        let header = Header(kid: keyID)
        let initiatedAt = Date(timeIntervalSince1970: TimeInterval(Int(Date().timeIntervalSince1970)))
        let expiresAt = Date(timeIntervalSince1970: TimeInterval(Int(Date().timeIntervalSince1970)) + 60*10)
        
        let claims = AppstoreConnectClaims(iss: issuerID, iat: initiatedAt, exp: expiresAt, aud: "appstoreconnect-v1")
        var ACJWT = JWT(header: header, claims: claims)
        
//        let privateKeyPath = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("AuthKey.p8")
//        guard let privateKey: Data = try? Data(contentsOf: privateKeyPath, options: .alwaysMapped) else {
//            print("Could not get file...")
//            throw AuthServiceError.apiKeyDataUnreadable
//        }
        
        guard let apiKeyData = apiKey.data(using: .utf8) else {
            print("Could not make apit key to Data")
            throw AuthServiceError.apiKeyDataUnreadable
        }
        
        let jwtSigner = JWTSigner.es256(privateKey: apiKeyData)
        
        guard let signedJWT = try? ACJWT.sign(using: jwtSigner) else {
            print("Could not sign token...")
            throw AuthServiceError.jwtTokenUnsignable
        }
        
        return signedJWT
    }
}

enum AuthServiceError: Error {
    case notInitialized
    case apiKeyWrongFormat
    case apiKeyDataUnreadable
    case jwtTokenUnsignable
    case unexpected
}
