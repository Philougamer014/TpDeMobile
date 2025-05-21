//
//  CharacterViewModel.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


import Foundation

class CharacterViewModel: ObservableObject {
    @MainActor
    func checkCharacterExists() async -> Bool {
        do {
            let _: CharacterModel = try await Services().fetchWithToken(endpoint: "mapventure/character")
            return true
        } catch {
            print("Character check failed: \(error)")
            return false
        }
    }
}

