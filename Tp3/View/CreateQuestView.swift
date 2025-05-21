//
//  CreateQuestView.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//

import SwiftUI
import CoreLocation  

struct CreateQuestView: View {
    var currentLocation: CLLocationCoordinate2D
    @State private var questDesc = ""
    @Environment(\.dismiss) var dismiss
    private let questService = QuestServices()

    var body: some View {
        Form {
            Section(header: Text("New Quest")) {
                TextField("Description", text: $questDesc)

                Button("Create") {
                    Task {
                        do {
                            _ = try await questService.createQuest(
                                latitude: currentLocation.latitude,
                                longitude: currentLocation.longitude,
                                desc: questDesc
                            )
                            dismiss()
                        } catch {
                            print("Failed to create quest: \(error)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Create Quest")
    }
}
