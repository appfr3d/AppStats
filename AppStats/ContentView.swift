//
//  ContentView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 18/11/2023.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession
import Charts

struct ContentView: View {
    @EnvironmentObject var appStatsModel: AppStatsModel
    @State var isSettingsVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                switch appStatsModel.state {
                case .success(let subscriberModelData):
                    HomeView().environmentObject(subscriberModelData)
                case .authServiceError(let error):
                    switch error {
                    case .notInitialized:
                        InsertCredentialsView()
                    default:
                        AuthServiceErrorView(error: error)
                    }
                case .salesServiceError(let error):
                    SalesServiceErrorView(error: error)
                case .notInitialized:
                    InsertCredentialsView()
                case .loading:
                    LoadingDataView()
                }
            }
            .padding()
            .navigationTitle("AppStats 📈")
            .toolbar {
                NavigationLink(destination: SettingsView()) { Image(systemName: "gear") .foregroundColor(.black) }
            }
            .onAppear {
                Task(priority: .medium) {
                    try await appStatsModel.initiateAppStatsModel()
                }
            }
        }
    }
}

#Preview {
    let appStatsModel = AppStatsModel()
    return ContentView()
        .environmentObject(appStatsModel)
}
