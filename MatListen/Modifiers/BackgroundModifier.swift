//
//  BackgroundModifier.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct BackgroundColorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .background(color.edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func backgroundColor(_ color: Color) -> some View {
        self.modifier(BackgroundColorModifier(color: color))
    }
}
