//
//  SettingsInfoView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 23/12/2023.
//

import SwiftUI

struct SettingsInfoView: View {
    private func openLink(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    var body: some View {
        VStack {
            Text("To fetch data from AppStore Connect you need to provide some credentials. These can all be found on the AppStore Connect website, and some can only be accessed on the desktop version of the side. We reccomend finding these credentials on your computer.")
                .font(.headline)
            
            Text("All the credentials are securly stored on Keychain, and not shared with anyone besides Apple! Not convinced? This app is Open Source, so chek the sourceode for yourself by pressing here.")
                .italic()
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .onTapGesture {
                    openLink("https://www.github.com/appfr3d/appstats")
                }
                
        }
        .padding(.bottom)
    }
}

struct InfoText: View {
    let info: String
    
    var body: some View {
        Text(info)
            .italic()
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

#Preview {
    SettingsInfoView()
}
