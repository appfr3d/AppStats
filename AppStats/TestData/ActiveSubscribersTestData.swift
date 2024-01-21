//
//  ActiveSubscribersTestData.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 10/12/2023.
//

import Foundation

class ActiveSubscribersTestData {
    fileprivate static func getBaseReportRow(subscribers: Double, date: Date, country: String, subscriptionName: String) -> SubscriptionReport {
        let report = SalesReportSubscription(subscribers: subscribers, country: country, subscriptionName: subscriptionName)
        return SubscriptionReport(report: report, date: date)
    }
    
    static func getActiveSubscribers() -> [SubscriptionReport] {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return [
            getBaseReportRow(subscribers: 1359, date: dateformatter.date(from: "2023-12-01")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-01")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1354, date: dateformatter.date(from: "2023-12-02")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-02")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1335, date: dateformatter.date(from: "2023-12-03")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-03")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1332, date: dateformatter.date(from: "2023-12-04")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-04")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1327, date: dateformatter.date(from: "2023-12-05")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-05")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1319, date: dateformatter.date(from: "2023-12-06")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
            getBaseReportRow(subscribers: 277, date: dateformatter.date(from: "2023-12-06")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 279, date: dateformatter.date(from: "2023-12-07")!, country: "DK", subscriptionName: "Blur Premium Three Months"),
            getBaseReportRow(subscribers: 1343, date: dateformatter.date(from: "2023-12-07")!, country: "NO", subscriptionName: "Blur Premium Monthly"),
        ]
    }
    
}



