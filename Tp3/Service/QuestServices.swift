//
//  GameServices.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-30.
//


import Foundation
class QuestServices: Services {

    func fetchAll() async throws -> [Quest] {
        return try await fetchWithToken(endpoint: "mapventure/available-quests")
    }

    func createQuest(latitude:Double, longitude:Double, desc:String)async throws->Quest {
        let dto = QuestDTO( latitude: latitude, longitude: longitude, description: desc)
        return try await postRequestWithToken(endpoint: "mapventure/create-quest", dto: dto)
    }
    
    func completeQuest(dto: CompleteQuestDTO) async throws -> SuccessMessage {
        try await postRequestWithToken(endpoint: "mapventure/complete-quest", dto: dto)
    }
}
