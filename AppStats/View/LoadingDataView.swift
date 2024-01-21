//
//  LoadingDataView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 16/12/2023.
//

import SwiftUI

struct LoadingDataView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Loading...")
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
}

#Preview {
    LoadingDataView()
}
