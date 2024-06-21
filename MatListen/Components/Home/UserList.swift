//
//  HouseholdList.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import SwiftUI

struct HouseholdList: View {
    private let houseHoldService = HouseHoldService()
    private let userService = UserService()
    @Binding var user: User
    @StateObject private var houseHoldMembersVM: HouseHoldMembersViewModel = HouseHoldMembersViewModel()
    
    var body: some View {
        Group {
            if user.householdID != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(houseHoldMembersVM.members, id: \.id) { member in
                            VStack {
                                Image(member.avatar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                
                                Text(member.username)
                                    .customFont(size: 15, weight: .regular)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    HStack {
                        Image(user.avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        Text(user.username)
                            .customFont(size: 15, weight: .regular)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            if let householdId = user.householdID {
                fetchHouseHold(householdId: householdId)
            }
        }
    }
    
    private func fetchHouseHold(householdId: Int) {
        houseHoldService.getHouseHoldById(id: householdId) { result in
            switch result {
            case .success(let houseHold):
                fetchHouseHoldMembers(memberIds: houseHold.userIDs)
            case .failure(let error):
                print("Error fetching HouseHold: \(error.localizedDescription)")
                // Handle error
            }
        }
    }
    
    private func fetchHouseHoldMembers(memberIds: [Int]) {
        let group = DispatchGroup()
        
        for memberId in memberIds {
            group.enter()
            if houseHoldMembersVM.members.first(where: { $0.id == memberId }) != nil{
                // Member already fetched, skip fetching
                group.leave()
            } else {
                userService.getUserById(id: memberId) { result in
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            houseHoldMembersVM.members.append(user)
                        }
                    case .failure(let error):
                        print("Error fetching user: \(error.localizedDescription)")
                        // Handle error
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            // Optionally handle completion if needed
        }
    }
}
