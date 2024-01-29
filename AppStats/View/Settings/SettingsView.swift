//
//  SettingsView.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 14/12/2023.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var appStatsModel: AppStatsModel
    @Environment(\.dismiss) var dismiss
    
    @State private var apiKey = getFileImportState(fromValue: keychainService.loadSecretValue(forKey: kKeychainAPIKey))
    @State private var vendorNumber = keychainService.loadSecretValue(forKey: kKeychainVendorNumber) ?? ""
    @State private var keyId = keychainService.loadSecretValue(forKey: kKeychainKeyId) ?? ""
    @State private var issuerId = keychainService.loadSecretValue(forKey: kKeychainIssuerId) ?? ""
    
    func saveCredentialsToKeychain() async throws {
        switch apiKey {
        case .success(let value):
            let isSuccess = keychainService.saveSecretValue(value, forKey: kKeychainAPIKey)
            print("Tried to save API Key, got: \(isSuccess)")
            break
        default:
            break
        }
        let _ = keychainService.saveSecretValue(vendorNumber, forKey: kKeychainVendorNumber)
        let _ = keychainService.saveSecretValue(keyId, forKey: kKeychainKeyId)
        let _ = keychainService.saveSecretValue(issuerId, forKey: kKeychainIssuerId)
        do {
            try await appStatsModel.initiateAppStatsModel()
        } catch let error {
            print("Got error when trying to save credentials: \(error)")
        }
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    SettingsInfoView()
                    SettingsAPIKeyFileImport(state: $apiKey) {
                        APIKeyInfoView()
                    }
                    SettingsTextField(text: $vendorNumber, placeholder: "Vendor Number") {
                        VendorNumberInfoView()
                    }
                    SettingsTextField(text: $keyId, placeholder: "Key ID") {
                        KeyIDInfoView()
                    }
                    SettingsTextField(text: $issuerId, placeholder: "Issuer ID") {
                        IssuerIDInfoView()
                    }
                    Button("Save") {
                        Task(priority: .medium) {
                            try await saveCredentialsToKeychain()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            .navigationTitle("AppStore Connect Credentials")
            .padding([.top, .horizontal])
            .background(Color(.systemGroupedBackground))
            
        }
    }
}


#Preview {
    let appStatsModel = AppStatsModel()
    return SettingsView()
        .environmentObject(appStatsModel)
}
