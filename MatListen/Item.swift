//
//  Item.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftData

struct Item: Identifiable, Codable {
    var id: Int
    var name: String
    var image: String?
    let ean: String
    var current_price: Double?
    var store: Store?
    var price_history: [PriceHistory]
}

struct Store: Codable {
    var name: String
    var code: String
    var url: String
}

struct PriceHistory: Codable, Identifiable {
    var id: UUID { UUID() }
    var price: Double
    var date: String
}

struct GroupedItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: String?
    var products: [Item]
    
    var lowestPrice: Double {
          let prices = products.flatMap { $0.price_history.map { $0.price } }
          return prices.min() ?? 0.0
      }

    static func == (lhs: GroupedItem, rhs: GroupedItem) -> Bool {
        return lhs.id == rhs.id
    }
}
