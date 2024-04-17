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
    case error(SalesReportStateError)
    case success(SalesReportService)
    case notInitialized
}

final class SalesReportState: ObservableObject {
    @Published private(set) var state: SalesReportStateEnum = .notInitialized
    
    func initialize(authService: AuthService) {
        do {
            let service = try self.createSalesReportService(authService: authService)
            self.state = .success(service)
        } catch {
            if let myError = error as? SalesReportStateError {
                self.state = .error(myError)
            } else {
                self.state = .error(.unknown)
            }
        }
    }
    
    func createSalesReportService(authService: AuthService) throws -> SalesReportService {
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
        return SalesReportService(client: client, vendorNumber: authService.vendorNumber)
    }
}
