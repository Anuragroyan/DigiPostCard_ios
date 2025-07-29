//
//  PostCardListView.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import SwiftUI

struct PostCardListView: View {
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
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(filteredCards) { card in
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(hex: card.hexColor))
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)

                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("📁 Folder")
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(6)

                                    Spacer()

                                    // Edit and Delete buttons
                                    HStack(spacing: 16) {
                                        Button {
                                            editingCard = card
                                            showingForm = true
                                        } label: {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.black)
                                        }

                                        Button {
                                            service.deleteCard(card)
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.trailing, 8)
                                }
                                .padding(.top, 12)
                                .padding(.horizontal, 12)

                                HStack(alignment: .top) {
                                    // Left: Message
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Message")
                                            .font(.headline.bold())
                                            .foregroundColor(.black)

                                        Text(card.message)
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()
                                        .frame(width: 1)
                                        .background(Color.black.opacity(0.7))
                                        .padding(.horizontal, 8)

                                    // Right: To/From
                                    VStack(alignment: .leading, spacing: 5) {
                                        Group {
                                            Text("To")
                                                .font(.headline.bold())
                                            Text(card.receiver)
                                                .font(.subheadline.weight(.semibold))
                                            Text(card.toAddress)
                                                .font(.caption)
                                                .foregroundColor(.black.opacity(0.8))
                                        }

                                        Divider().padding(.vertical, 4)

                                        Group {
                                            Text("From")
                                                .font(.headline.bold())
                                            Text(card.sender)
                                                .font(.subheadline.weight(.semibold))
                                            Text(card.fromAddress)
                                                .font(.caption)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                HStack {
                                    Spacer()
                                    Text("#\(card.hexColor.uppercased())")
                                        .font(.caption2)
                                        .foregroundColor(.black.opacity(0.7))
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("📮 Digital PostCards")
            .toolbar {
                Button(action: {
                    editingCard = nil
                    showingForm = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search by message, sender, color...")
            .sheet(isPresented: $showingForm) {
                PostCardForm(service: service, cardToEdit: editingCard)
            }
        }
    }
}
