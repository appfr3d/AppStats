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
    
    @ViewBuilder
    var body: some View {
        switch grouping {
        case .none:
            ChartViewSubscriptrionsTotal()
        case .appName:
            ChartViewSubscriptrionsTotal()
        case .country:
            ChartViewSubscriptrionsByCountry()
        case .subscriptionName:
            ChartViewSubscriptrionsBySubscriptionName()
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
                    Circle().frame(width: 10)
                }
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(sub.report.subscribers)")
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
                .foregroundStyle(by: .value("Subscription name", sub.report.country))
                .symbol {
                    Circle().frame(width: 10)
                }
                
                PointMark(
                    x: .value("Date", sub.date),
                    y: .value("Subscribers", sub.report.subscribers)
                )
                .annotation {
                    Text("\(sub.report.subscribers)")
                }
                
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
                    Text("\(sub.report.subscribers)")
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

#Preview("Subsription Name") {
    @State var grouping = SubscriptionGroup.subscriptionName
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    return ChartView(grouping: $grouping)
        .environmentObject(SubscriptionModelData(data: data))
}

