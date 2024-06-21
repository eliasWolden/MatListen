//
//  User.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let avatar: String
    let householdID: Int?
}

struct HouseHold: Codable, Identifiable {
    var id: Int?
    var houseHoldName: String
    var userIDs: [Int]
}
