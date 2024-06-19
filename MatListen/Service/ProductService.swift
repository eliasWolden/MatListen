//
//  ProductService.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import Foundation
import SwiftData

struct ApiResponse: Codable {
    let data: [Item]
    let meta: Meta
}

struct Meta: Codable {
    let current_page: Int
    let per_page: Int
    let total: Int?
}


struct Config {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "API-Keys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let key = plist["PRODUCT_API_KEY"] as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Config.plist'.")
        }
        return key
    }
}

class ApiService {
    private let baseUrl = "https://kassal.app/api/v1/products"
    private let token = Config.apiKey

    func fetchProducts(searchQuery: String, page: Int = 1, completion: @escaping (Result<[GroupedItem], Error>) -> Void) {
        guard var components = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL"])))
            return
        }

        components.queryItems = [
            URLQueryItem(name: "search", value: searchQuery),
            URLQueryItem(name: "sort", value: "name_asc"),
            URLQueryItem(name: "exclude_without_ean", value: "1"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        #if DEBUG
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        #endif

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }

                do {
                    #if DEBUG
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("API Response: \(jsonString)")
                    }
                    #endif

                    let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                    let filteredData = apiResponse.data.filter { $0.current_price != nil && !$0.ean.isEmpty }
                    let groupedData = self.groupProducts(filteredData)
                    completion(.success(groupedData))
                } catch {
                    #if DEBUG
                    print("Decoding error: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Failed JSON: \(jsonString)")
                    }
                    #endif
                    completion(.failure(error))
                }

            case 429:
                completion(.failure(NSError(domain: "", code: 429, userInfo: [NSLocalizedDescriptionKey: "Too Many Requests. Please try again later."])))

            default:
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
            }
        }.resume()
    }

    private func groupProducts(_ products: [Item]) -> [GroupedItem] {
        var groupedDict = [String: GroupedItem]()
        var nameDict = [String: String]()

        for product in products {
            let ean = product.ean
            let normalizedName = normalizeName(product.name)

            if var existingGroup = groupedDict[ean] {
                existingGroup.products.append(product)
                groupedDict[ean] = existingGroup
            } else {
                let newGroup = GroupedItem(name: product.name, image: product.image, products: [product])
                groupedDict[ean] = newGroup
                nameDict[normalizedName] = ean
            }
        }

        for product in products {
            let ean = product.ean
            let normalizedName = normalizeName(product.name)

            if let existingEAN = nameDict[normalizedName], existingEAN != ean {
                if var existingGroup = groupedDict[existingEAN] {
                    if !existingGroup.products.contains(where: { $0.ean == ean }) {
                        existingGroup.products.append(product)
                        groupedDict[existingEAN] = existingGroup
                    }
                }
            }
        }

        return Array(groupedDict.values)
    }

    private func normalizeName(_ name: String) -> String {
        return name.lowercased()
            .replacingOccurrences(of: "[^a-z0-9]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
