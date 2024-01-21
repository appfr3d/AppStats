//
//  KeyIDInfoView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 23/12/2023.
//

import SwiftUI

struct KeyIDInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("The App Store Connect API requires a JSON Web Token (JWT) to authorize each request you make to the API. The JWT is generated using an API key downloaded from App Store Connect.")
                Text("If you have not generatet an API key, please see instructions on how to do so in the API Key Info.")
                    .padding(.bottom)
                NumberedText(number: 1, text: "Log in to App Store Connect, select Users and Access, and then select the API Keys tab.")
                NumberedText(number: 2, text: "Find the name of the key you created, and then see the Key ID on the same row.")
                NumberedText(number: 3, text: "Manually insert the Key ID in the AppStats settings page.")
            }
        }
    }
}

#Preview {
    KeyIDInfoView()
}
