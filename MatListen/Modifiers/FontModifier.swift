//
//  FontModifier.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct CustomFontModifier: ViewModifier {
    var size: CGFloat
    var weight: FontWeight

    func body(content: Content) -> some View {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "Poppins-Regular"
        case .bold:
            fontName = "Poppins-Bold"
        case .thin:
            fontName = "Poppins-Thin"
        }
        return content.font(.custom(fontName, size: size))
    }
}

enum FontWeight {
    case regular
    case bold
    case thin
}

extension View {
    func customFont(size: CGFloat, weight: FontWeight = .regular) -> some View {
        self.modifier(CustomFontModifier(size: size, weight: weight))
    }
}
