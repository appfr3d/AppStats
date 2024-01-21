//
//  AppStatsModel.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 21/12/2023.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum AppStatsState  {
    case success(subscriberModelData: SubscriptionModelData)
    case authServiceError(error: AuthServiceError)
    case salesServiceError(error: SalesServiceError)
    case notInitialized
    case loading
}

class AppStatsModel: ObservableObject {
    @Published var state: AppStatsState = .notInitialized
    @Published var salesReportService: SalesReportService? = nil {
        didSet {
            print("didSet salesReportService: \(String(describing: salesReportService))")
            
            guard let _ = salesReportService else {
                print("Sales Report service is nil")
                return
            }
            
            Task(priority: .medium) {
                try await getSubscriptionData()
            }
        }
    }
    @Published var authService: AuthService? = nil {
        didSet {
            print("didSet authService: \(String(describing: authService))")
            guard let authService = authService else {
                print("Auth service is nil")
                state = .authServiceError(error: .notInitialized)
                return
            }
            
            state = .loading
            
            let sessionConfiguration = URLSessionConfiguration.default
            
            let signedToken: String
            do {
                signedToken = try authService.getSignedToken()
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
                return
            }

            print("Signed Token: \(signedToken)")
            
            sessionConfiguration.httpAdditionalHeaders = [
                "Authorization": "Bearer \(signedToken)"
            ]
            
            let session = URLSession(configuration: sessionConfiguration)
            let transportConfiguration = URLSessionTransport.Configuration(session: session)
            let client = Client(
                serverURL: try! Servers.server1(),
                transport: URLSessionTransport(configuration: transportConfiguration)
            )
            
            salesReportService = SalesReportService(client: client, vendorNumber: authService.vendorNumber)
        }
    }
    
    func getSubscriptionData() async throws {
        print("Getting subscription data")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let salesReportService = salesReportService else {
            state = .salesServiceError(error: .notInitialized)
            return
        }
        
        let data: [SubscriptionReport]
        do {
            data = try await salesReportService.getSubscriptionsFromLastSevenDays()
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
            return
        }
        
        DispatchQueue.main.async {
            self.state = .success(subscriberModelData: SubscriptionModelData(data: data))
        }
    }
    
    func checkKeychainStatus() {
        let apiKey = getFileImportState(fromValue: keychainService.loadSecretValue(forKey: kKeychainAPIKey))
        let vendorNumber = keychainService.loadSecretValue(forKey: kKeychainVendorNumber)
        let keyId = keychainService.loadSecretValue(forKey: kKeychainKeyId)
        let issuerId = keychainService.loadSecretValue(forKey: kKeychainIssuerId)
        
        if let ki = keyId, let vn = vendorNumber, let ii = issuerId, case let .success(ak) = apiKey {
            print("APIKey       : \(ak)")
            print("Vendor number: \(vn)")
            print("KeyID        : \(ki)")
            print("IssuerID     : \(ii)")
            authService = AuthService(keyID: ki, vendorNumber: vn, issuerID: ii, apiKey: ak)
        }
        
    }
    
}
