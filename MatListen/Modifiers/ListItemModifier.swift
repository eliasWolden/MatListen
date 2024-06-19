//
//  ListItemModifier.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct ListItemModifier: ViewModifier {
    var backgroundColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
    }
}

extension View {
    func listItemStyle(backgroundColor: Color, textColor: Color) -> some View {
        self.modifier(ListItemModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}
