
/*
 import Foundation
 
 @MainActor
 class NotesViewModel: ObservableObject {
 @Published var quests: [Quest] = []
 private let dataManager = AppDataManager.shared
 
 init() {
 quests = dataManager.fetchQuests()
 }
 
 func fetchQuests() {
 quests = dataManager.fetchQuests()
 }
 
 func addQuest(id:UUID, latitude:Double, longitude:Double, desc:String, creatorName: String) {
 dataManager.addQuest(id: id, latitude:latitude, longitude: longitude, desc: desc, creatorName : creatorName)
 fetchQuests()
 }
 }
 */
