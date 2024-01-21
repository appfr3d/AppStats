//
//  SettingsTextField.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 20/12/2023.
//

import SwiftUI

struct SettingsTextField<Content: View>: View {
    @Binding var text: String
    let placeholder: String
    var content: () -> Content
    
    @State var isInfoVisible: Bool = false
    
    var body: some View {
        VStack {
            Text(placeholder).font(.subheadline)
            HStack {
                TextField(placeholder, text: $text, axis: .vertical).textFieldStyle(.roundedBorder)
                Button {
                    isInfoVisible = true
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .padding(.bottom)
        .sheet(isPresented: $isInfoVisible) {
            VStack {
                Text("How to find \(placeholder)")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                content()
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    @State var text = "Test text"
    return SettingsTextField(text: $text, placeholder: "Placeholder") {
        Text("Hello")
    }
}
