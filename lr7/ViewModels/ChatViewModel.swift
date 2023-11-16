//
//  ChatViewModel.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation
import Combine

extension ChatView {
    @MainActor class ViewModel: ObservableObject {

        private let currentUserData = UserDefaults.standard.data(forKey: "currentUser")
        @Published var sender: User = User(id: 0, login: "", email: "", phone: "")
        @Published var receiver: User
        @Published var messages = [Message]()
        @Published var message = ""

        private var bag = Set<AnyCancellable>()

        init(receiver: User) {
            self.receiver = receiver
            setup()
            fetchMessages()
        }

        private func setup() {
            Task {
                sender = try JSONDecoder().decode(User.self, from: currentUserData!)
            }
        }

        func fetchMessages() {
            Task {
                messages = try await NetworkService.shared.getMessages(interlocutorId: receiver.id, meId: sender.id)
            }
        }

        func sendMessage() {
            Task {
                let hashedMessage = try MessageHasherService.shared.encrypt(string: self.message)
                let message = CreateMessageCommand(
                    textHash: hashedMessage,
                    senderId: sender.id,
                    receiverId: receiver.id
                )
                _ = try await NetworkService.shared.postMessage(message: message)
                self.message = ""
                fetchMessages()
            }
        }
    }
}
