//
//  SettingsFileImport.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 21/12/2023.
//

import SwiftUI

enum FileImportState {
    case success(value: String)
    case error
    case empty
}

struct SettingsAPIKeyFileImport<Content: View>: View {
    @Binding var state: FileImportState
    @State private var importing = false
    @State var isInfoVisible: Bool = false
    var content: () -> Content
    
    var body: some View {
        HStack {
            Button {
                importing = true
            } label: {
                switch state {
                case .success(_):
                    Label("Working API key file!", systemImage: "checkmark.seal")
                case .error:
                    Label("Error with API key, import again", systemImage: "x.circle")
                case .empty:
                    Label("Import API key file", systemImage: "square.and.arrow.down")
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.data]
            ) { result in
                switch result {
                case .success(let file):
                    print(file.absoluteString)
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    if !gotAccess {
                        print("Did not get access...")
                        return
                    }
                    
                    guard let fileData = try? Data(contentsOf: file) else {
                        print("Could not create Data from file")
                        return
                    }
                    
                    guard let stringData = String(data: fileData, encoding: .ascii) else {
                        print("Could not create String from fileData")
                        return
                    }
                    
                    print("Got data as string!")
                    print(stringData)
                    
                    state = getFileImportState(fromValue: stringData)
                    
                    file.stopAccessingSecurityScopedResource()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            Button {
                isInfoVisible = true
            } label: {
                Image(systemName: "info.circle")
            }
        }
        .padding(.bottom)
        .sheet(isPresented: $isInfoVisible) {
            VStack {
                Text("How to find the API Key file")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                content()
                Spacer()
            }
        }
    }
}

func getFileImportState(fromValue: String?) -> FileImportState {
    guard let value = fromValue else {
        return .empty
    }
    
    if value.isEmpty {
        return .empty
    }
    
    if value.contains("-----BEGIN PRIVATE KEY-----") && value.contains("-----END PRIVATE KEY-----") {
        return .success(value: value)
    }
    
    return .error
}

#Preview {
    @State var state = FileImportState.success(value: "Test key")
    return SettingsAPIKeyFileImport(state: $state) {
        Text("Hello")
    }
}
