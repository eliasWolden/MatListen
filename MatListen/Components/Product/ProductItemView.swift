//
//  ProductItemView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import SwiftUI
import Foundation

struct ProductItemView: View {
    var groupedItem: GroupedItem
    @Binding var showPopup: Bool
    @Binding var selectedProduct: GroupedItem?
    
    var onSelect: () -> Void

    var body: some View {
        ZStack {
            Button(action: {
                onSelect()
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        if let imageUrl = groupedItem.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 100, height: 100)
                                }
                            }
                            .frame(width: 100, height: 100)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        Spacer()
                    }

                    Text(groupedItem.name)
                        .customFont(size: 17, weight: .thin)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(height: 40)
                    
                    Text(String(format: "%.2fkr", groupedItem.lowestPrice))
                        .customFont(size: 13, weight: .regular)
                        .multilineTextAlignment(.leading)
                        .frame(height: 20)
                }
                .padding()
                .background(Color.white)
                .frame(width: 150, height: 250)
                .cornerRadius(8)
                .shadow(radius: 8)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showPopup && groupedItem.id == selectedProduct?.id {
                Color.black.opacity(0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPopup = false
                    }
                ProductSelectionPopup(group: groupedItem, addToShoppingList: { item in
                    // Add item to shopping list
                    showPopup = false
                }) {
                    showPopup = false
                }
                .zIndex(1)
            }
        }
    }
}
