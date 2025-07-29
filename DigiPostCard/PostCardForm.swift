//
//  PostCardForm.swift
//  DigiPostCard
//
//  Created by Dungeon_master on 29/07/25.
//

import SwiftUI

struct PostCardForm: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var service: PostCardService
    var cardToEdit: PostCard?
    
    @State private var sender: String = ""
    @State private var receiver: String = ""
    @State private var fromAddress: String = ""
    @State private var toAddress: String = ""
    @State private var message: String = ""
    @State private var hexColor: String = "FF6F61"
    
    var isEditing: Bool { cardToEdit != nil }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sender & Receiver")) {
                    TextField("Sender Name", text: $sender)
                    TextField("Receiver Name", text: $receiver)
                }

                Section(header: Text("Addresses")) {
                    TextField("From Address", text: $fromAddress)
                    TextField("To Address", text: $toAddress)
                }

                Section(header: Text("Message")) {
                    TextField("Write your message", text: $message)
                }
                
                Section(header: Text("Hex Color Code")) {
                    TextField("e.g. FFA500", text: $hexColor)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                }
                
                Section {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: hexColor))
                        .frame(height: 100)
                        .overlay(
                            VStack {
                                Text("From: \(sender)").font(.caption).foregroundColor(.white)
                                Text("To: \(receiver)").font(.caption).foregroundColor(.white)
                                Text(message)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.top, 4)
                            }
                            .padding()
                        )
                }
            }
            .navigationTitle(isEditing ? "Edit Card" : "New Card")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let card = PostCard(
                            id: cardToEdit?.id,
                            sender: sender,
                            receiver: receiver,
                            fromAddress: fromAddress,
                            toAddress: toAddress,
                            message: message,
                            hexColor: hexColor.uppercased(),
                            timestamp: Date()
                        )
                        isEditing ? service.updateCard(card) :
                            service.addCard(sender: sender, receiver: receiver, fromAddress: fromAddress, toAddress: toAddress, message: message, hexColor: hexColor)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                if let card = cardToEdit {
                    self.sender = card.sender
                    self.receiver = card.receiver
                    self.fromAddress = card.fromAddress
                    self.toAddress = card.toAddress
                    self.message = card.message
                    self.hexColor = card.hexColor
                }
            }
        }
    }
}
