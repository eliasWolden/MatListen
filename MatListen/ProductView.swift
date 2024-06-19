//
//  ProductView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftUI

struct ProductView: View {
    @State private var searchQuery: String = ""
    @State private var groupedProducts: [GroupedItem] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var currentPage: Int = 1
    @State private var isFetchingMore: Bool = false
    @Binding var shoppingList: [Item]
    @State private var showModal: Bool = false
    @State private var selectedGroup: GroupedItem?

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack {
                    Spacer().frame(height: 120)

                    ProductGrid(
                        groupedProducts: groupedProducts,
                        columns: columns,
                        onProductSelect: selectGroup,
                        onLoadMore: loadMoreProducts,
                        isFetchingMore: isFetchingMore
                    )
                }

                if showModal, let group = selectedGroup {
                    ProductSelectionPopup(group: group, addToShoppingList: addToShoppingList) {
                        showModal = false
                    }
                    .zIndex(1)
                }

                VStack {
                    Text("Søk etter vare")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .customFont(size: 24, weight: .bold)
                        .background(Color.customBackground)

                    SearchBar(searchQuery: $searchQuery, onCommit: searchProducts, onTap: clearSearch)
                        .background(Color.customBackground)
                        .onChange(of: searchQuery) {
                            searchProducts()
                        }
                }
                .frame(maxWidth: .infinity)
                .background(Color.customBackground)
                .zIndex(10)
            }
        }
    }

    private func clearSearch() {
        searchQuery = ""
        groupedProducts = []
        errorMessage = nil
    }

    private func selectGroup(_ group: GroupedItem) {
        selectedGroup = group
        DispatchQueue.main.async {
            showModal = true
        }
    }

    private func searchProducts() {
        isLoading = true
        errorMessage = nil
        currentPage = 1

        ApiService().fetchProducts(searchQuery: searchQuery, page: currentPage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let groupedProducts):
                    self.groupedProducts = groupedProducts
                case .failure(let error):
                    if (error as NSError).code == 429 {
                        self.errorMessage = "Too many requests. Please try again later."
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func loadMoreProducts() {
        isFetchingMore = true
        currentPage += 1

        ApiService().fetchProducts(searchQuery: searchQuery, page: currentPage) { result in
            DispatchQueue.main.async {
                self.isFetchingMore = false
                switch result {
                case .success(let moreGroupedProducts):
                    self.groupedProducts.append(contentsOf: moreGroupedProducts)
                case .failure(let error):
                    if (error as NSError).code == 429 {
                        self.errorMessage = "Too many requests. Please try again later."
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func addToShoppingList(product: Item) {
        if !shoppingList.contains(where: { $0.id == product.id }) {
            shoppingList.append(product)
        }
    }
}
