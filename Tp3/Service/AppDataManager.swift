//
//  AppDataManager.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-30.
//

/*
 import Foundation
 import SwiftData
 
 class AppDataManager {
 static let shared = AppDataManager()
 let container: ModelContainer
 
 private init() {
 let schema = Schema([Quest.self])
 let config = ModelConfiguration()
 self.container = try! ModelContainer(for: schema, configurations: config)
 }
 
 @MainActor func addQuest(id:UUID, latitude:Double, longitude:Double, desc:String, creatorName: String) {
 let newQuest = Quest(id: id, latitude:latitude, longitude: longitude, desc: desc, creatorName : creatorName)
 let context = container.mainContext
 context.insert(newQuest)
 try? context.save()
 }
 
 @MainActor func fetchQuests() -> [Quest] {
 let context = container.mainContext
 let fetchDescriptor = FetchDescriptor<Quest>(sortBy: [SortDescriptor(\.id)])
 return (try? context.fetch(fetchDescriptor)) ?? []
 }
 }
 /*
  "id": 0,
  "latitude": 0,
  "longitude": 0,
  "description": "string",
  "creator_name": "string"
  */
 */
