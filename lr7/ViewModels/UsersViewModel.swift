//
//  UsersViewModel.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation

extension UsersView {
    @MainActor class ViewModel: ObservableObject {
        var authenticationService: AuthenticationService
        private let currentUserData = UserDefaults.standard.data(forKey: "currentUser")
        private var currentUser: User = User(id: 0, login: "", email: "", phone: "")

        @Published var users = [User]()

        init(authenticationService: AuthenticationService) {
            self.authenticationService = authenticationService
            setup()
            fetchUsers()
        }

        private func setup() {
            Task {
                currentUser = try JSONDecoder().decode(User.self, from: currentUserData!)
            }
        }

        func fetchUsers() {
            Task {
                users = try await NetworkService.shared.getUsers(id: currentUser.id)
            }
        }
    }
}
