//
//  HomeView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 14/12/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var subscriptionModelData: SubscriptionModelData
    @State var grouping: SubscriptionGroup = .none
    
    var body: some View {
        VStack {
            Picker("Grouping?", selection: $grouping) {
                Text("Total").tag(SubscriptionGroup.none)
                Text("Country").tag(SubscriptionGroup.country)
                Text("Sub name").tag(SubscriptionGroup.subscriptionName)
            }
            .pickerStyle(.segmented)
            Text("Subscribers: \(subscriptionModelData.currentTotal)")
            ChartView(grouping: $grouping)
        }
    }
}

#Preview {
    let data = ActiveSubscribersTestData.getActiveSubscribers()
    let subsModelData = SubscriptionModelData(data: data)
    return HomeView().environmentObject(subsModelData)
}
