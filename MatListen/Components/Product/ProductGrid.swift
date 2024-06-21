//
//  ProductGrid.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct ProductGrid: View {
    var groupedProducts: [GroupedItem]
    var columns: [GridItem]
    var onLoadMore: () -> Void
    var isFetchingMore: Bool

    @State private var selectedProduct: GroupedItem?
    @State private var showPopup: Bool = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(groupedProducts) { groupedItem in
                    ProductItemView(groupedItem: groupedItem, showPopup: $showPopup, selectedProduct: $selectedProduct) {
                        if selectedProduct?.id != groupedItem.id {
                            selectedProduct = groupedItem
                            showPopup = true
                        } else {
                            showPopup.toggle()
                        }
                    }
                    .onAppear {
                        if groupedItem == groupedProducts.last && !isFetchingMore {
                            onLoadMore()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
