//
//  CharacterModel.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-05-21.
//


struct CharacterModel: Decodable {
    let id: Int
    let name: String
    let hp: Int
    let attack: Int
    let magic: Int
    let level: Int
    let className: String
}
