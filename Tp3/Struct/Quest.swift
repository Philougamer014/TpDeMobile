import Foundation
import SwiftData




class Quest:Decodable {
    var id: UUID
    var latitude: Double
    var longitude: Double
    var desc: String
    var creatorName: String
    
    init(id: UUID, latitude: Double, longitude: Double, desc: String, creatorName: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.desc = desc
        self.creatorName = creatorName
    }
}

struct QuestDTO: Encodable {
    var latitude: Double
    var longitude: Double
    var desc: String
    
    init(latitude: Double, longitude: Double, desc: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.desc = desc
    }
}

/*
 {
   "id": 0,
   "latitude": 0,
   "longitude": 0,
   "description": "string",
   "creator_name": "string"
 }
 */
