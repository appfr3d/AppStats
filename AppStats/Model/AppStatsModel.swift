//
//  AppStatsModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 21/12/2023.
//
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI
import Combine

enum AppStatsState {
    case success(subscriberModelData: SubscriptionModelData)
    case authServiceError(error: AuthServiceError)
    case salesServiceError(error: SalesServiceError)
    case notInitialized
    case loading
}

class AppStatsModel: ObservableObject {
    @Published var state: AppStatsState = .notInitialized
    @Published var isLoading: Bool = false
    @Published var salesReportService: SalesReportService?
    
    @Published var authState: AuthState = AuthState()
    @Published var salesReportState: SalesReportState = SalesReportState()
    
    func getSubscriptionData() async throws {
        print("Getting subscription data")
        
        guard let salesReportService = salesReportService else {
            DispatchQueue.main.async {
                self.state = .salesServiceError(error: .notInitialized)
            }
            return
        }
        
        do {
            
            let data = try await salesReportService.getSubscriptionsFromLastSevenDays()
            DispatchQueue.main.async {
                self.state = .success(subscriberModelData: SubscriptionModelData(data: data))
            }
        } catch let error {
            if let myError = error as? SalesServiceError {
                print("unexpected")
                DispatchQueue.main.async {
                    self.state = .salesServiceError(error: myError)
                }
            } else {
                print("Generic error")
                DispatchQueue.main.async {
                    self.state = .salesServiceError(error: .unexpected(code: -1))
                }
            }
        }
    }
    
    func initiateAppStatsModel() async throws {
        DispatchQueue.main.async {
            self.authState.initialize()
            if case let .success(authService) = self.authState.state {
                self.salesReportState.initialize(authService: authService)
            }
        }
        do {
            try await self.getSubscriptionData()
        } catch {
            print("Error getting subscription data: \(error)")
        }
    }
    
    func initiateWidgetAppStatsModel() async throws {
        self.authState.initialize()
        if case let .success(authService) = self.authState.state {
            self.salesReportState.initialize(authService: authService)
        }
        
        do {
            try await self.getSubscriptionData()
        } catch {
            print("Error getting subscription data: \(error)")
        }
    }
}
