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

enum AppStatsState {
    case success(subscriberModelData: SubscriptionModelData)
    case authServiceError(error: AuthServiceError)
    case salesServiceError(error: SalesServiceError)
    case notInitialized
    case loading
}

class AppStatsModel: ObservableObject {
    @Published var state: AppStatsState = .notInitialized
    @Published var salesReportService: SalesReportService?
    @Published var authService: AuthService?
    
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
    
    func createAuthService() -> AuthService? {
        let apiKey = getFileImportState(fromValue: keychainService.loadSecretValue(forKey: kKeychainAPIKey))
        let vendorNumber = keychainService.loadSecretValue(forKey: kKeychainVendorNumber)
        let keyId = keychainService.loadSecretValue(forKey: kKeychainKeyId)
        let issuerId = keychainService.loadSecretValue(forKey: kKeychainIssuerId)
        
        print("APIKey       : \(apiKey)")
        print("Vendor number: \(String(describing: vendorNumber))")
        print("KeyID        : \(String(describing: keyId))")
        print("IssuerID     : \(String(describing: issuerId))")
        
        if let ki = keyId, let vn = vendorNumber, let ii = issuerId, case let .success(ak) = apiKey {
            print("APIKey       : \(ak)")
            print("Vendor number: \(vn)")
            print("KeyID        : \(ki)")
            print("IssuerID     : \(ii)")
            return AuthService(keyID: ki, vendorNumber: vn, issuerID: ii, apiKey: ak)
        }
        return nil
    }
    
    func createSalesReportService() -> SalesReportService? {
        guard let authService = authService else {
            print("Auth service is nil")
            DispatchQueue.main.async {
                self.state = .authServiceError(error: .notInitialized)
            }
            return nil
        }
        
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        do {
            let signedToken = try authService.getSignedToken()
            
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": "Bearer \(signedToken)"
            ]
            let session = URLSession(configuration: sessionConfiguration)
            let transportConfiguration = URLSessionTransport.Configuration(session: session)
            let client = Client(
                serverURL: try! Servers.server1(),
                transport: URLSessionTransport(configuration: transportConfiguration)
            )
            
            
            print("createSalesReportService success")
            
            return SalesReportService(client: client, vendorNumber: authService.vendorNumber)
        } catch let error {
            if let myError = error as? AuthServiceError {
                DispatchQueue.main.async {
                    self.state = .authServiceError(error: myError)
                }
            } else {
                print("Generic error")
                DispatchQueue.main.async {
                    self.state = .authServiceError(error: .unexpected)
                }
            }
            return nil
        }
    }
    
    func initiateAppStatsModel() async throws {
        self.authService = self.createAuthService()
        self.salesReportService = self.createSalesReportService()
        do {
            try await self.getSubscriptionData()
        } catch {
            print("Error getting subscription data: \(error)")
        }
    }
}
