//
//  ProfileView.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


import SwiftUI

struct ProfileView: View {
    @State private var character: CharacterModel?
    
    var body: some View {
        NavigationView {
            VStack {
                if let character = character {
                    Form {
                        Section(header: Text("Character")) {
                            Text("Name: \(character.name)")
                            Text("Class: \(character.className)")
                            Text("Level: \(character.level)")
                            Text("HP: \(character.hp)")
                            Text("Attack: \(character.attack)")
                            Text("Magic: \(character.magic)")
                        }
                    }
                } else {
                    ProgressView("Loading character...")
                }
            }
            .navigationTitle("Profile")
            .task {
                await loadCharacter()
            }
        }
    }

    func loadCharacter() async {
        do {
            character = try await Services().fetchWithToken(endpoint: "mapventure/character")
            
        } catch {
            print("Failed to load character: \(error)")
        }
    }
}
