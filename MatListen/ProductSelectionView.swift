//
//  ProductSelectionView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

// The main view structure for the product selection popup
struct ProductSelectionPopup: View {
    var group: GroupedItem // Grouped items to display in the popup
    var addToShoppingList: (Item) -> Void // Function to add an item to the shopping list
    var dismiss: () -> Void // Function to dismiss the popup

    var body: some View {
        ZStack {
            // Background overlay with a semi-transparent black color
            Color.black.opacity(0)
                .edgesIgnoringSafeArea(.all) // Extends the overlay to the edges of the screen
                .onTapGesture {
                    dismiss() // Dismiss the popup when the overlay is tapped
                }
            
            VStack {
                // Display a message if there are no products available in the group
                if group.products.isEmpty {
                    Text("No products available for this group.")
                        .foregroundColor(.gray) // Gray color for the text
                        .padding() // Padding around the text
                } else {
                    // Horizontal scroll view to display available products
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // Loop through each product in the group
                            ForEach(group.products) { product in
                                VStack {
                                    // Check if the product has a store and a current price
                                    if let store = product.store, let price = product.current_price {
                                        Button(action: {
                                            print("Adding product with ID: \(product.id)") // Log the product ID
                                            addToShoppingList(product) // Add the product to the shopping list
                                            dismiss() // Dismiss the popup
                                        }) {
                                            VStack {
                                                // Display the store's image
                                                Image(store.name)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25, height: 25) // Scaled size for the image
                                                // Display the product price
                                                Text("\(price, specifier: "%.2f") Kr")
                                                    .customFont(size: 7, weight: .regular) // Scaled font for the price
                                                    .foregroundColor(.black) // Black color for the text
                                            }
                                            .frame(width: 35, height: 35) // Scaled size for the entire product view
                                        }
                                    }
                                }
                                .padding(4) // Reduced padding around each product view
                                .background(Color.white) // White background for each product view
                                .cornerRadius(4) // Reduced rounded corners
                                .shadow(radius: 1.5) // Scaled shadow for a subtle elevation effect
                            }
                        }
                        .padding(.horizontal, 5) // Reduced padding around the horizontal stack
                    }
                }
            }
            .background(Color.clear) // Transparent background for the VStack
            .shadow(radius: 10) // Scaled shadow for the overall popup
            .frame(maxWidth: .infinity) // Maximum width for the popup
            .transition(.scale) // Scale transition for popup appearance/disappearance
        }
    }
}
