//
//  SubscriptionChartView.swift
//  AppStatsWidgetExtension
//
//  Created by Alfred Lieth Årøe on 27/01/2024.
//

import SwiftUI

struct SubscriptionChartView: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    @Binding var grouping: SubscriptionGroup
    
    var body: some View {
        ChartView(grouping: $grouping)
    }
}

#Preview {
    @State var grouping = SubscriptionGroup.subscriptionName
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    return SubscriptionChartView(grouping: $grouping)
        .environmentObject(SubscriptionModelData(data: data))
}
