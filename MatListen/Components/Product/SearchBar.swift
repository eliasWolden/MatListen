//
//  SearchBar.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var searchQuery: String
    var onCommit: () -> Void
    var onTap: () -> Void

    var body: some View {
        TextField("Søk etter produkter...", text: $searchQuery, onCommit: onCommit)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onTapGesture {
                onTap()
                
            }
    }
}
