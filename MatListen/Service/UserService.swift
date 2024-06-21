//
//  UserService.swift
//  MatListen
//
//  Created by Elias Wolden on 20/06/2024.
//

import Foundation

struct UserApiResponse: Codable {
    let data: [Item]
    let meta: Meta
}

class UserService {
    private let baseUrl = "http://localhost:8080/api"

    func authenticateUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/authenticate") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        #if DEBUG
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Body: \(body)")
        #endif

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            print("Response Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch let decodingError {
                    print("Decoding Error: \(decodingError.localizedDescription)")
                    completion(.failure(decodingError))
                }
            case 401:
                print("Authentication failed")
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])))
            default:
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
            }
        }.resume()
    }

    func createUser(username: String, password: String, avatar: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/AppUser") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["username": username, "password": password, "avatar": avatar]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        #if DEBUG
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Body: \(body)")
        #endif

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            print("Response Status Code: \(httpResponse.statusCode)")

            switch httpResponse.statusCode {
            case 201:
                completion(.success(true))
            default:
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
            }
        }.resume()
    }

    func updateUser(id: Int, username: String, avatar: String, householdID: Int, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/AppUser/\(id)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["id": id, "username": username, "avatar": avatar, "householdID": householdID] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
#if DEBUG
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Body: \(body)")
#endif
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    let updatedUser = try JSONDecoder().decode(User.self, from: data)
                    print("Update User Successful")
                    completion(.success(updatedUser))
                } catch let decodingError {
                    print("Decoding Error: \(decodingError.localizedDescription)")
                    completion(.failure(decodingError))
                }
            default:
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
            }
        }.resume()
    }
        
        func getUserById(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
            guard let url = URL(string: "\(baseUrl)/AppUser/\(id)") else {
                print("Invalid URL")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }

                print("Response Status Code: \(httpResponse.statusCode)")

                guard let data = data else {
                    print("No data received")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                switch httpResponse.statusCode {
                case 200:
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        completion(.success(user))
                    } catch let decodingError {
                        print("Decoding Error: \(decodingError.localizedDescription)")
                        completion(.failure(decodingError))
                    }
                case 404:
                    print("User not found")
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                default:
                    print("HTTP Error: \(httpResponse.statusCode)")
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                }
            }.resume()
        }
    }

