//
//  CreateCharacterDTO.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


struct CreateCharacterDTO: Encodable {
    let classId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case name
    }
}
