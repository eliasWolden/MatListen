//
//  ProductSelectionView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct ProductSelectionPopup: View {
    var group: GroupedItem
    var addToShoppingList: (Item) -> Void
    var dismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismiss()
                }
            
            VStack {
                if group.products.isEmpty {
                    Text("No products available for this group.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(group.products) { product in
                                VStack {
                                    if let store = product.store, let price = product.current_price {
                                        Button(action: {
                                            print("Adding product with ID: \(product.id)")
                                            addToShoppingList(product)
                                            dismiss()
                                        }) {
                                            VStack {
                                                Image(store.name)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                Text("\(price, specifier: "%.2f") Kr")
                                                    .customFont(size: 20)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                            }
                        }
                    }
                }
            }
            .background(Color.clear)
            .shadow(radius: 20)
            .frame(maxWidth: .infinity)
            .transition(.scale)
        }
    }
}
