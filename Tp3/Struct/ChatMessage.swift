//
//  ChatMessage.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-23.
//

import Foundation

struct ChatMessage: Identifiable {
    var id: String
    var text: String
    var senderId: String
    var receiverId: String
    var timestamp: Date
}
