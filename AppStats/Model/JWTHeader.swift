//
//  JWTHeader.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 28/11/2023.
//

import Foundation

struct JWTHeader {
    let alg: String = "ES256"
    let kid: String
    let typ: String = "JWT"
}
