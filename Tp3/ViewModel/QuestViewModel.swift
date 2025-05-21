import Foundation
import CoreLocation

@MainActor
class QuestViewModel: ObservableObject {
    @Published var quests: [Quest] = []
    private let questService = QuestServices()

    func loadQuests() async {
        do {
            quests = try await questService.fetchAll()
        } catch {
            print("Failed to load quests: \(error)")
        }
    }

    func attemptQuestCompletion(quest: Quest, userLocation: CLLocationCoordinate2D) async {
        let questLocation = CLLocation(latitude: quest.latitude, longitude: quest.longitude)
        let currentLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = questLocation.distance(from: currentLocation)

        if distance <= 50 { 
            do {
                let result = try await questService.completeQuest(id: quest.id.hashValue)
                print("Quest Completed: \(result.description)")
                await loadQuests()
            } catch {
                print("Failed to complete quest: \(error)")
            }
        } else {
            print("Too far from quest.")
        }
    }
}
