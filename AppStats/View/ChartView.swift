//
//  ChartView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 05/12/2023.
//

import SwiftUI
import Charts

struct ChartView: View {
    @Binding var grouping: SubscriptionGroup
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    
    @ViewBuilder
    var body: some View {
        switch grouping {
        case .none:
            ChartViewSubscriptrionsTotal()
        case .appName:
            SubscriptionsLineChartView(reportData: subscriptionModelData.appNameData, dataSource: \.appName)
        case .country:
            SubscriptionsLineChartView(reportData: subscriptionModelData.countryData, dataSource: \.country)
        case .subscriptionName:
            SubscriptionsLineChartView(reportData: subscriptionModelData.subscriptionNameData, dataSource: \.subscriptionName)
        }
    }
}

struct SubscriptionsLineChartView: View {
    var reportData: [SubscriptionReport]
    var dataSource: KeyPath<SalesReportSubscription, String>
    
    init(reportData: [SubscriptionReport], dataSource: KeyPath<SalesReportSubscription, String>) {
        self.reportData = reportData
        self.dataSource = dataSource
    }
    
    var body: some View {
        VStack {
            Chart(reportData) { sub in
                LineMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .interpolationMethod(.catmullRom)
                .symbol {
                    Circle().frame(width: 8)
                }
                .foregroundStyle(by: .value("Subscription name", sub.report[keyPath: dataSource]))
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(Int(sub.report.subscribers))").font(.footnote)
                }
                .foregroundStyle(by: .value("Subscription name", sub.report[keyPath: dataSource]))
                
            }
        }
    }
}


struct ChartViewSubscriptrionsTotal: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData

    var body: some View {
        VStack {
            Chart(subscriptionModelData.totalData) { sub in
                LineMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .interpolationMethod(.catmullRom)
                .symbol {
                    Circle().frame(width: 8)
                }
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(Int(sub.report.subscribers))").font(.footnote)
                }
                
            }
        }
    }
}

struct ChartViewSubscriptrionsByAppName: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    
    var body: some View {
        VStack {
            Chart(subscriptionModelData.appNameData) { sub in
                LineMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Subscription name", sub.report.country))
                .symbol {
                    Circle().frame(width: 10)
                }
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(Int(sub.report.subscribers))")
                }
                
            }
        }
    }
}

struct ChartViewSubscriptrionsByCountry: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    
    var body: some View {
        VStack {
            Chart(subscriptionModelData.countryData) { sub in
                LineMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .interpolationMethod(.catmullRom)
                .symbol {
                    Circle().frame(width: 10)
                }
                .foregroundStyle(by: .value("Subscription name", sub.report.country))
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(Int(sub.report.subscribers))")
                }
                .foregroundStyle(by: .value("Subscription name", sub.report.country))
                
            }
        }
    }
}

struct ChartViewSubscriptrionsBySubscriptionName: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    
    var body: some View {
        VStack {
            Chart(subscriptionModelData.subscriptionNameData) { sub in
                LineMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Subscription name", sub.report.subscriptionName))
                .symbol {
                    Circle().frame(width: 10)
                }
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(Int(sub.report.subscribers))")
                }
                
            }
        }
    }
}

#Preview("None") {
    @State var grouping = SubscriptionGroup.none
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    return ChartView(grouping: $grouping)
        .environmentObject(SubscriptionModelData(data: data))
}

#Preview("Country") {
    @State var grouping = SubscriptionGroup.country
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    return ChartView(grouping: $grouping)
        .environmentObject(SubscriptionModelData(data: data))
}

#Preview("Subscription Name") {
    @State var grouping = SubscriptionGroup.subscriptionName
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    return ChartView(grouping: $grouping)
        .environmentObject(SubscriptionModelData(data: data))
}
