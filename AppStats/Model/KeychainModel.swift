//
//  KeychainModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 04/01/2024.
//

import Foundation



func getKeychainServiceName() -> String {
    let id = Bundle.main.bundleIdentifier

    guard let bundleId = id else {
        return "no.appfred.AppStats.shared"
    }
  
    if Bundle.main.bundleURL.pathExtension == "appex" {
      return "\(bundleId.replacingOccurrences(of: ".AppStatsWidget", with: "")).shared"
    }
    
    return "\(bundleId).shared"
}

let kKeychainServiceName = getKeychainServiceName()
let keychainService = KeychainService(service: kKeychainServiceName)

let kKeychainAPIKey = "@api_key"
let kKeychainVendorNumber = "@vendor_number"
let kKeychainKeyId = "@key_id"
let kKeychainIssuerId = "@issuer_id"
