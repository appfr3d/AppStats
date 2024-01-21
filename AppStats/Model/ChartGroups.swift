//
//  ChartGroups.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 10/12/2023.
//

import Foundation


enum SubscriptionGroup: String {
    case none = "none"
    case appName = "appName"
    case country = "country"
    case subscriptionName = "subscriptionName"
}

struct SubscriptionGroupByResult {
    let data: [ActiveSubscribers]
}

// Generic function for grouping
func groupSubscriptionBy<T>(list: [SubscriptionReport], keyClosure: (SubscriptionReport) -> T) -> [SubscriptionReport] {
    var groupedItems: [String: SubscriptionReport] = [:]
    
    for item in list {
        let closure = keyClosure(item)
        let key = "\(item.date)-\(closure)"
        
        if var existingItem = groupedItems[key] {
            // Update the existing item by adding subscribers
            existingItem.report.subscribers += item.report.subscribers
            groupedItems[key] = existingItem
        } else {
            // Create a new combined item
            groupedItems[key] = item
        }
    }
    
    var result: [SubscriptionReport] = Array(groupedItems.values)
    result.sort(by: { $0.date < $1.date })
    
    for subscriber in result {
        print(subscriber)
    }
    
    return result
}
