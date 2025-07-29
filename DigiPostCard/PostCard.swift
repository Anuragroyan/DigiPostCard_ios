//
//  PostCard.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import Foundation
import FirebaseFirestoreSwift

struct PostCard: Identifiable, Codable {
    @DocumentID var id: String?
    var sender: String
    var receiver: String
    var fromAddress: String
    var toAddress: String
    var message: String
    var hexColor: String
    var timestamp: Date
}

