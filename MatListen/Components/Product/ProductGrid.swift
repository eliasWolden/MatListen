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
    
    var onProductSelect: (GroupedItem) -> Void
    
    var onLoadMore: () -> Void
    
    var isFetchingMore: Bool

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
               
                ForEach(groupedProducts) { groupedItem in
                    ProductItemView(groupedItem: groupedItem) {
                        onProductSelect(groupedItem)
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
