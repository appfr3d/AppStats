//
//  VendorNumberInfoView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 23/12/2023.
//

import SwiftUI

struct VendorNumberInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Vendor Numbers are needed for downloading reports using the App Store Connect API.")
                    .padding(.bottom)
                NumberedText(number: 1, text: "Log in to App Store Connect, from homepage, click Payments and Financial Reports.")
                NumberedText(number: 2, text: "Find the VendorNumber in the top left corner, below your organization name.")
                NumberedText(number: 3, text: "Manually insert the VendorNumber in the AppStats settings page.")
            }
        }
    }
}

#Preview {
    VendorNumberInfoView()
}
