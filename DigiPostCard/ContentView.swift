//
//  ContentView.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var service = PostCardService()
    @State private var showingForm = false
    @State private var editingCard: PostCard?
    @State private var searchText = ""

    var filteredCards: [PostCard] {
        if searchText.isEmpty {
            return service.cards
        } else {
            return service.cards.filter {
                $0.message.lowercased().contains(searchText.lowercased()) ||
                $0.hexColor.lowercased().contains(searchText.lowercased()) ||
                $0.sender.lowercased().contains(searchText.lowercased()) ||
                $0.receiver.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCards) { card in
                    VStack(alignment: .leading, spacing: 6) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("From: \(card.sender)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("To: \(card.receiver)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text(card.message)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(hex: card.hexColor))
                        .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("From Address: \(card.fromAddress)")
                            Text("To Address: \(card.toAddress)")
                            Text("Color Code: #\(card.hexColor.uppercased())")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .font(.caption)
                    }
                    .padding(.vertical, 6)
                    .onTapGesture {
                        editingCard = card
                        showingForm = true
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { service.deleteCard(filteredCards[$0]) }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("📮 PostCards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingCard = nil
                        showingForm = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search sender, receiver, message...")
            .sheet(isPresented: $showingForm) {
                PostCardForm(service: service, cardToEdit: editingCard)
            }
        }
    }
}



#Preview {
    ContentView()
}
