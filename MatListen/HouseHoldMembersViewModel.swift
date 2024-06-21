//
//  HouseHoldMembersViewModel.swift
//  MatListen
//
//  Created by Elias Wolden on 20/06/2024.
//

import Foundation
import SwiftUI

class HouseHoldMembersViewModel: ObservableObject {
    @Published var members: [User] = []
}
