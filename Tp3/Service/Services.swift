//
//  Services.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-30.
//


import Foundation


class Services {
    private let baseURL = "https://api-mobile.cegeplabs.qc.ca/"
    
    func fetchAll<T: Decodable>(endpoint: String) async throws -> [T] {
        let path = baseURL + endpoint
        
        guard let url = URL(string: path) else {
            throw HTTPError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HTTPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
        } catch {
            throw HTTPError.invalidData
        }
    }
    
    func fetchAllWithToken<T: Decodable>(endpoint: String) async throws -> [T] {
        let path = baseURL + endpoint
        
        guard let apiToken = TokenHandler.retrieveToken() else {
            throw HTTPError.invalidToken
        }
        
        guard let url = URL(string: path) else {
            throw HTTPError.invalidURL
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HTTPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
        } catch {
            throw HTTPError.invalidData
        }
    }

    func fetchById<T: Decodable>(endpoint: String, id: Int) async throws -> T {
        let path = baseURL + endpoint + "/" + String(describing: id)

        guard let url = URL(string: path) else {
            throw HTTPError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HTTPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw HTTPError.invalidData
        }
    }
    
    func postRequest<T: Encodable, U: Decodable>(endpoint: String, dto: T) async throws -> U? {
        let urlString = "https://api-mobile.cegeplabs.qc.ca/todo/\(endpoint)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let requestBody = try encoder.encode(dto)
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw API Response: \(jsonString)")
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(U.self, from: data)
    }


    
    func createWithDummyToken<T: Encodable, U: Decodable>(endpoint: String, dto: T) async throws -> U {
        let apiToken = "supersecrettoken"
        let path = baseURL + endpoint
        
        guard let url = URL(string: path) else {
            throw HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let requestBody = try encoder.encode(dto)
        
        request.httpBody = requestBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw HTTPError.statusCode(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(U.self, from: data)
            
        } catch {
            throw HTTPError.invalidData
        }
        
    }
    
    func postRequestWithToken<T: Encodable, U: Decodable>(endpoint: String, dto: T) async throws -> U {
        let path = baseURL + endpoint
        
        guard let apiToken = TokenHandler.retrieveToken() else {
            throw HTTPError.invalidToken
        }
        
        guard let url = URL(string: path) else {
            throw HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let requestBody = try encoder.encode(dto)
        
        request.httpBody = requestBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw HTTPError.statusCode(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(U.self, from: data)
            
        } catch {
            throw HTTPError.invalidData
        }
        
    }

}

enum HTTPError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case statusCode(Int)
    case unknownError(Error)
    case invalidToken
}