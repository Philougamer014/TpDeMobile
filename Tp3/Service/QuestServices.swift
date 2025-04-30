//
//  GameServices.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-30.
//


import Foundation
class QuestServices: Services {

    func fetchAll() async throws -> [Quest] {
        return try await fetchAll(endpoint: "mapventure/available-quests")
    }

    func createQuest(latitude:Double, longitude:Double, desc:String)async throws->Quest {
        let dto = QuestDTO( latitude: latitude, longitude: longitude, desc: desc)
        return try await postRequestWithToken(endpoint: "games/game", dto: dto)
    }
    
    func completeQuest(id:Int) async throws->String{
        return try await postRequestWithToken(endpoint: "games/game", dto:id)
    }
}
