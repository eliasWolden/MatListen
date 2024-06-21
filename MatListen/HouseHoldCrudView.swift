//
//  HouseHoldCrudView.swift
//  MatListen
//
//  Created by Elias Wolden on 20/06/2024.
//

import SwiftUI

struct HouseHoldCrudView: View {
    @State private var houseHoldId: Int?
    @State private var houseHoldName: String = ""
    @State private var responseMessage: String = ""
    
    private let houseHoldService = HouseHoldService()
    private let userService = UserService()
    @Binding var user: User
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("HouseHold Name", text: $houseHoldName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                createNewHouseHold()
            }) {
                Text("Create HouseHold")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                if let id = houseHoldId {
                    updateExistingHouseHold(id: id)
                } else {
                    responseMessage = "No HouseHold ID available"
                }
            }) {
                Text("Update HouseHold")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                if let id = houseHoldId {
                    deleteHouseHoldById(id: id)
                } else {
                    responseMessage = "No HouseHold ID available"
                }
            }) {
                Text("Delete HouseHold")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                if let id = houseHoldId {
                    addUserToHouseHold(id: id)
                } else {
                    responseMessage = "No HouseHold ID available"
                }
            }) {
                Text("Add User to HouseHold")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Text(responseMessage)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func createNewHouseHold() {
        let newHouseHold = HouseHold(id: nil, houseHoldName: houseHoldName, userIDs: [])
        
        houseHoldService.createHouseHold(houseHold: newHouseHold) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseDTO):
                    responseMessage = "Created HouseHold with ID: \(responseDTO.id)"
                    houseHoldId = responseDTO.id
                    addUserToCreatedHouseHold(houseHoldId: responseDTO.id)
                case .failure(let error):
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func addUserToCreatedHouseHold(houseHoldId: Int) {
        houseHoldService.addUserToHouseHold(houseHoldId: houseHoldId, userId: user.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    responseMessage += "\nAdded User to HouseHold: \(message)"
                    updateUserHouseId(user: user, houseHoldId: houseHoldId)
                case .failure(let error):
                    responseMessage = "Error adding user: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func updateExistingHouseHold(id: Int) {
        let updatedHouseHold = HouseHold(id: id, houseHoldName: houseHoldName, userIDs: [user.id])
        
        houseHoldService.updateHouseHold(id: id, houseHold: updatedHouseHold) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let houseHold):
                    responseMessage = "Updated HouseHold: \(houseHold.houseHoldName)"
                case .failure(let error):
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func deleteHouseHoldById(id: Int) {
        houseHoldService.deleteHouseHold(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    responseMessage = "Deleted HouseHold: \(message)"
                    houseHoldId = nil
                case .failure(let error):
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func addUserToHouseHold(id: Int) {
        houseHoldService.addUserToHouseHold(houseHoldId: id, userId: user.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    responseMessage = "Added User to HouseHold: \(message)"
                    updateUserHouseId(user: user, houseHoldId: id)
                case .failure(let error):
                    responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func updateUserHouseId(user: User, houseHoldId: Int) {
        userService.updateUser(id: user.id, username: user.username, avatar: user.avatar, householdID: houseHoldId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser):
                    responseMessage += "\nUser updated: \(updatedUser)"
                case .failure(let error):
                    responseMessage = "Error updating user: \(error.localizedDescription)"
                }
            }
        }
    }
}
