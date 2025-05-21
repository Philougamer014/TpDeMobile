class Quest: Decodable, Identifiable {
    var id: Int  
    var latitude: Double
    var longitude: Double
    var description: String
    var creatorName: String?

    init(id: Int, latitude: Double, longitude: Double, description: String, creatorName: String?) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.creatorName = creatorName
    }
}

struct QuestDTO: Encodable {
    var latitude: Double
    var longitude: Double
    var description: String

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case description = "description"
    }
}
