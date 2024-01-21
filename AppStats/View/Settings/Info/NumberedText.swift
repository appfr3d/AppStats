//
//  NumberedText.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 24/12/2023.
//

import SwiftUI

struct NumberedText: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack {
            Text("\(number). ")
            Text(text)
        }
    }
}


#Preview {
    NumberedText(number: 1, text: "This is the first point.")
}
