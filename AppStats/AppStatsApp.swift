//
//  AppStatsApp.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 18/11/2023.
//

import SwiftUI

@main
struct AppStatsApp: App {
    //@State private var subscriptionModelData = SubscriptionModelData(data: ActiveSubscribersTestData.getActiveSubscribers())
    @StateObject var appStatsModel = AppStatsModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStatsModel)
        }
    }
}
