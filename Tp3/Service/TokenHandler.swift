//
//  TokenHandler.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-30.
//


import Foundation
import KeychainAccess
import JWTDecode

class TokenHandler {
    static let keychain = Keychain(service: "com.games")
    
    static func saveToken(token: String) -> Bool {
        do {
            try keychain.set(token, key: "jwt_token")
            return true
        } catch {
            return false
        }
    }
    
    static func retrieveToken() -> String? {
        do {
            return try keychain.get("jwt_token")
        } catch {
            print("Error retrieving token")
            return nil
        }
    }
    
    static func isTokenExpired() -> Bool {
        do {
            guard let token = retrieveToken() else {
                return true
            }
            
            let jwt = try decode(jwt: token)
            if let exp = jwt.expiresAt {
                return exp > Date()
            } else {
                return true
            }
        } catch {
            return true
        }
    }
}