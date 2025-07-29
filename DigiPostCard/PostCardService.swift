//
//  PostCardService.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostCardService: ObservableObject {
    @Published var cards: [PostCard] = []

    private var db = Firestore.firestore()
    private let collection = "postcards"

    init() {
        fetchCards()
    }

    func fetchCards() {
        db.collection(collection)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching cards: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.cards = documents.compactMap { doc in
                        try? doc.data(as: PostCard.self)
                    }
                }
            }
    }

    func addCard(sender: String, receiver: String, fromAddress: String, toAddress: String, message: String, hexColor: String) {
        let newCard = PostCard(
            sender: sender,
            receiver: receiver,
            fromAddress: fromAddress,
            toAddress: toAddress,
            message: message,
            hexColor: hexColor,
            timestamp: Date()
        )

        do {
            try db.collection(collection).addDocument(from: newCard)
            print("✅ Document added successfully")
        } catch {
            print("❌ Error adding document: \(error.localizedDescription)")
        }
    }

    func updateCard(_ card: PostCard, completion: ((Error?) -> Void)? = nil) {
        guard let id = card.id else {
            completion?(NSError(domain: "PostCardService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Card ID is missing"]))
            return
        }

        do {
            try db.collection(collection).document(id).setData(from: card, merge: true, encoder: Firestore.Encoder()) { error in
                if let error = error {
                    print("❌ Error updating card: \(error.localizedDescription)")
                } else {
                    print("✅ Card updated successfully")
                }
                completion?(error)
            }
        } catch {
            print("❌ Encoding error while updating card: \(error.localizedDescription)")
            completion?(error)
        }
    }

    func deleteCard(_ card: PostCard) {
        guard let id = card.id else { return }

        db.collection(collection).document(id).delete { error in
            if let error = error {
                print("❌ Error deleting postcard: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.cards.removeAll { $0.id == id }
                    print("✅ Postcard deleted successfully")
                }
            }
        }
    }
}
