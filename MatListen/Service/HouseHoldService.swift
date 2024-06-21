//
//  HouseHoldService.swift
//  MatListen
//
//  Created by Elias Wolden on 20/06/2024.
//

import Foundation

// MARK: - Models

struct HouseHoldApiResponse: Codable {
    let data: [HouseHold]
    let meta: Meta
}

struct HouseHoldResponseDTO: Codable {
    let id: Int
    let message: String
}

// MARK: - HouseHoldService

class HouseHoldService {
    private let baseUrl = "http://localhost:8080/api/household"
    
    // Fetch HouseHold by ID
    func getHouseHoldById(id: Int, completion: @escaping (Result<HouseHold, Error>) -> Void) {
        print("Fetching HouseHold with ID: \(id)")
        guard let url = URL(string: "\(baseUrl)/\(id)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"])
                print("No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let houseHold = try JSONDecoder().decode(HouseHold.self, from: data)
                print("Successfully fetched HouseHold: \(houseHold)")
                completion(.success(houseHold))
            } catch {
                print("Error decoding HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Create new HouseHold
    func createHouseHold(houseHold: HouseHold, completion: @escaping (Result<HouseHoldResponseDTO, Error>) -> Void) {
        print("Creating new HouseHold: \(houseHold)")
        guard let url = URL(string: baseUrl) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(houseHold)
            request.httpBody = jsonData
        } catch {
            print("Error encoding HouseHold: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"])
                print("No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let responseDTO = try JSONDecoder().decode(HouseHoldResponseDTO.self, from: data)
                print("Successfully created HouseHold: \(responseDTO)")
                completion(.success(responseDTO))
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Update existing HouseHold
    func updateHouseHold(id: Int, houseHold: HouseHold, completion: @escaping (Result<HouseHold, Error>) -> Void) {
        print("Updating HouseHold with ID: \(id)")
        guard let url = URL(string: "\(baseUrl)/\(id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(houseHold)
            request.httpBody = jsonData
        } catch {
            print("Error encoding HouseHold: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"])
                print("No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let updatedHouseHold = try JSONDecoder().decode(HouseHold.self, from: data)
                print("Successfully updated HouseHold: \(updatedHouseHold)")
                completion(.success(updatedHouseHold))
            } catch {
                print("Error decoding updated HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Delete HouseHold by ID
    func deleteHouseHold(id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        print("Deleting HouseHold with ID: \(id)")
        guard let url = URL(string: "\(baseUrl)/\(id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"])
                print("No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let responseMessage = try JSONDecoder().decode([String: String].self, from: data)
                if let message = responseMessage["message"] {
                    print("Successfully deleted HouseHold: \(message)")
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unexpected response"])
                    print("Unexpected response")
                    completion(.failure(error))
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Add User to HouseHold
    func addUserToHouseHold(houseHoldId: Int, userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        print("Adding User with ID: \(userId) to HouseHold with ID: \(houseHoldId)")
        guard let url = URL(string: "\(baseUrl)/\(houseHoldId)/addUser/\(userId)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding user to HouseHold: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"])
                print("No data received")
                completion(.failure(error))
                return
            }
            
            do {
                let responseMessage = try JSONDecoder().decode([String: String].self, from: data)
                if let message = responseMessage["message"] {
                    print("Successfully added user to HouseHold: \(message)")
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unexpected response"])
                    print("Unexpected response")
                    completion(.failure(error))
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
