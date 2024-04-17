//
//  SalesReportState.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 08/02/2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum SalesReportStateError: Error {
    case notInitialized
    
    case tsvFieldNotFound(fieldName: String)
    case dataNotGzipped

    case notFound
    case badRequest
    case forbidden
    case unauthorized
    
    case dateFormat

    case unexpected(code: Int)
    case unknown
}

enum SalesReportStateEnum {
    case error(error: SalesReportStateError)
    case success
    case notInitialized
}

final class SalesReportState: ObservableObject {
    @Published private(set) var state: SalesReportStateEnum = .notInitialized
    @Published var salesReportService: SalesReportService?
    
    func createSalesReportService(authService: AuthService) {
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
            self.salesReportService = SalesReportService(client: client, vendorNumber: authService.vendorNumber)
        } catch {
            if let myError = error as? SalesReportStateError {
                self.state = .error(error: myError)
            } else {
                self.state = .error(error: .unknown)
            }
        }
    }
}
