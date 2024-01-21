//
//  UserDefaultsModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 07/01/2024.
//

import Foundation


let kUserDefaultsSuiteName = "group.no.appfred.AppStats.shared"
let userDefaultsService = UserDefaults(suiteName: kUserDefaultsSuiteName) ?? UserDefaults()

let kUserDefaultsSubscriptionKey = "@subscription"

func getUserDefaultsSubscriptionKey(forDate: Date, andFrequency: Operations.salesReports_hyphen_get_collection.Input.Query.filter_lbrack_frequency_rbrack_PayloadPayload) -> String {
    let dateFormatter = DateFormatter()
    
    let baseKey = "\(kUserDefaultsSubscriptionKey)/\(andFrequency.rawValue)"

    switch andFrequency {
    case .DAILY:
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return "\(baseKey)/\(dateFormatter.string(from: forDate))"
    case .WEEKLY:
        dateFormatter.dateFormat = "yyyy/ww"
        return "\(baseKey)/\(dateFormatter.string(from: forDate))"
    case .MONTHLY:
        dateFormatter.dateFormat = "yyyy/MM"
        return "\(baseKey)/\(dateFormatter.string(from: forDate))"
    case .YEARLY:
        dateFormatter.dateFormat = "yyyy"
        return "\(baseKey)/\(dateFormatter.string(from: forDate))"
    }
}
