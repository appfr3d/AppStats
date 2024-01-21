//
//  KeychainModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 04/01/2024.
//

import Foundation

let kKeychainServiceName = "no.appfred.AppStats.shared"
let keychainService = KeychainService(service: kKeychainServiceName)

let kKeychainAPIKey = "@api_key"
let kKeychainVendorNumber = "@vendor_number"
let kKeychainKeyId = "@key_id"
let kKeychainIssuerId = "@issuer_id"
