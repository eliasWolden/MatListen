//
//  ShoppingListView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    @Binding var shoppingList: [Item]
    
    var totalPrice: Double {
        shoppingList.reduce(0) { $0 + ($1.current_price ?? 0) }
    }
    
    init(shoppingList: Binding<[Item]>) {
        self._shoppingList = shoppingList
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                VStack {
                    if totalPrice > 0 {
                    
                        List {
                        ForEach(shoppingList) { item in
                            ShoppingListItemView(item: item)
                        }
                      
                            TotalPriceView(totalPrice: totalPrice)
                        }
                    } else {
                        EmptyListView()
                    }
                }
            }
            .backgroundColor(.customBackground)
        }
    }
}

struct ShoppingListItemView: View {
    let item: Item
    
    var body: some View {
        VStack {
            HStack {
                if let storeName = item.store?.name {
                    Image(storeName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 20)
                } else {
                    Text("N/A")
                        .customFont(size: 15, weight: .regular)
                        .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
                }
                Text(item.name)
                    .customFont(size: 15, weight: .regular)
                    .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
                Spacer()
                if let price = item.current_price {
                    Text("\(price, specifier: "%.2f") kr")
                        .customFont(size: 15, weight: .thin)
                        .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
                } else {
                    Text("N/A")
                        .customFont(size: 15, weight: .regular)
                        .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
                }
            }
            Divider()
        }
    }
}

struct TotalPriceView: View {
    let totalPrice: Double
    
    var body: some View {
        Text("Totalt: \(totalPrice, specifier: "%.2f") kr")
            .customFont(size: 15, weight: .regular)
            .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
    }
}

struct EmptyListView: View {
    var body: some View {
        Text("Handlelisten er tom trykk på + for å legge til varer")
            .customFont(size: 20, weight: .regular)
            .listItemStyle(backgroundColor: .listItemBackground, textColor: .BlackTextColor)
    }
}
