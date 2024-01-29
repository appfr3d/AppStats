//
//  View+Extention.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 28/01/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
