//
//  AuthServiceErrorView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 22/12/2023.
//

import SwiftUI

struct AuthServiceErrorView: View {
    let error: AuthServiceError
    
    var body: some View {
        VStack {
            Spacer()
            Text("Authorization error. Check that your App Store Connect credentials correct in the settings")
            Text("Error reason: \(authServiceErrorReason(error: error))")
            Spacer()
        }
    }
    
    func authServiceErrorReason(error: AuthServiceError) -> String {
        switch error {
        case .apiKeyWrongFormat:
            "API key is formatted wrong"
        case .apiKeyDataUnreadable:
            "API key not readable"
        case .jwtTokenUnsignable:
            "JWT token unsignable"
        default:
            "Unknown"
        }
    }
}

#Preview {
    AuthServiceErrorView(error: .unexpected)
}
