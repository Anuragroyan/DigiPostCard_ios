//
//  DigiPostCardApp.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import SwiftUI
import Firebase

@main
struct PostCardApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            PostCardListView()
        }
    }
}
