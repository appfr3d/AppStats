//
//  SalesServiceErrorView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 22/12/2023.
//

import SwiftUI

struct SalesServiceErrorView: View {
    let error: SalesServiceError
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sales Service error. Check that your App Store Connect credentials are correct in the settings")
            Text("Error reason: \(salesServiceErrorReason(error: error))")
            Spacer()
        }
    }
    
    func salesServiceErrorReason(error: SalesServiceError) -> String {
        switch error {
        case .dataNotGzipped:
            "Did not get data in right format. Should be GZip"
        case .notFound:
            "Did not find any data"
        case .badRequest:
            "Bad request"
        case .forbidden:
            "Forbidden"
        case .unauthorized:
            "Unauthorized"
        case .dateFormat:
            "Could not format date"
        default :
            "Unknown"
        }
    }
}

#Preview {
    SalesServiceErrorView(error: .dataNotGzipped)
}
