//
//  APIKeyInfoView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 23/12/2023.
//

import SwiftUI

struct APIKeyInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("The App Store Connect API requires a JSON Web Token (JWT) to authorize each request you make to the API. The JWT is generated using an API key downloaded from App Store Connect.")
                    .padding(.bottom)
                
                Text("Generate an API Key and Assign It a Role")
                    .font(.title)
                Text("To generate keys, you must have an Admin account in App Store Connect. Also, it is only possible to do in the desktop version of App Store Connect, so please use a computer for these steps.")
                    .padding(.bottom)
                NumberedText(number: 1, text: "Log in to App Store Connect, select Users and Access, and then select the API Keys tab.")
                NumberedText(number: 2, text: "Click Generate API Key or the Add (+) button and enter a memorable name for the key, for instance \"AppStats Key\".")
                NumberedText(number: 3, text: "Under Access, select the \"Admin\" role for the key, and then click \"Generate\".")
                Text("The new key's name, key ID, a download link, and other information appears on the page. The \"Key ID\" is one of the other credentials needed to create the JWT, so if you havent already, insert it in the AppStats settings page.")
                    .padding(.bottom)
                
                Text("Download and Store the Private Key")
                    .font(.title)
                
                Text("Once you've generated your API key, it is available for download a single time.")
                    .padding(.bottom)
                NumberedText(number: 1, text: "Click \"Download API Key\" link next to the new API key. This will download a file with a name like \"AuthKey_XXXXXXXXXX.p8\"")
                NumberedText(number: 2, text: "AirDrop or otherwise share the .p8 file to your \"Files\" app on your iPhone") // TODO: Different name for iPhone/iPad/etc
                NumberedText(number: 3, text: "Finally, press the API Key button in the AppStats settings page, locate the .p8 file and select it.")
                
            }
            .padding()
            
        }
    }
}

#Preview {
    APIKeyInfoView()
}
