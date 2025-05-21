//
//  CharacterClass.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


import SwiftUI

struct CharacterClass: Identifiable, Decodable {
    let id: Int
    let name: String
    let baseAttack: Int
    let baseHp: Int
    let baseMagic: Int
}

struct CreateCharacterView: View {
    @State private var name = ""
    @State private var selectedClassId: Int? = nil
    @Environment(\.dismiss) var dismiss
    @State private var classes: [CharacterClass] = []
    var onCharacterCreated: (() -> Void)?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Character Info")) {
                    TextField("Name", text: $name)
                    Picker("Class", selection: $selectedClassId) {
                        ForEach(classes) { charClass in
                            Text(charClass.name).tag(Optional(charClass.id))
                        }
                    }
                }

                Button("Create Character") {
                    Task {
                        if let classId = selectedClassId {
                            let dto = CreateCharacterDTO(classId: classId, name: name)
                            if let result: SuccessMessage = try? await Services().postRequestWithToken(endpoint: "mapventure/create-character", dto: dto) {
                                print("Character creation response: \(result.message)")
                                onCharacterCreated?()
                            } else {
                                print("Failed to decode character creation response.")
                            }
                        }
                    }
                }



            }
            .navigationTitle("Create Character")
            .task {
                await loadCharacterClasses()
            }
        }
    }

    func loadCharacterClasses() async {
        do {
            print("Fetching character classes…")
            classes = try await Services().fetchWithToken(endpoint: "mapventure/character-classes")
            print("Loaded classes: \(classes.map { $0.name })")
        } catch {
            print("Failed to load character classes: \(error)")
        }
    }

}
