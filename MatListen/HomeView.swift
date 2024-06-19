//
//  HomeView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct HouseHoldView: View {
    @Binding var shoppingList: [Item]
    
    var body: some View {
        VStack {
            HStack {
                Text("Household Overview")
                    .customFont(size: 24, weight: .thin)
                    .foregroundColor(.white)
                    .padding()
                
            }
            ShoppingListView(shoppingList: $shoppingList)
        }
        .navigationTitle("HouseHold")
        .customFont(size: 16)
        .backgroundColor(.customBackground)
    }
}
