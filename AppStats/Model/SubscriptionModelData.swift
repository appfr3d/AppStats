//
//  ChartViewModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 05/12/2023.
//

import SwiftUI

class SubscriptionModelData: ObservableObject {
    var data: [SubscriptionReport]
    var totalData: [SubscriptionReport]
    var countryData: [SubscriptionReport]
    var subscriptionNameData: [SubscriptionReport]
    var appNameData: [SubscriptionReport]

    var avarage: Double {
        let sum = data.map { $0.report.subscribers }.reduce(0.0, +)
        return sum / Double(data.count)
    }
    
    var currentTotal : Int {
        guard let last = self.totalData.last else {
            return 0
        }
        
        return Int(last.report.subscribers)
    }
    
    init(data: [SubscriptionReport]) {
        self.data = data
        self.totalData = groupSubscriptionBy(list: data) { _ in "" }
        self.countryData = groupSubscriptionBy(list: data) { $0.report.country }
        self.subscriptionNameData = groupSubscriptionBy(list: data) { $0.report.subscriptionName }
        self.appNameData = groupSubscriptionBy(list: data) { $0.report.appName }
    }
}
