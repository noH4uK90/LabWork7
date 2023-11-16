//
//  RegistrationViewModel.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation

extension RegistrationView {
    @MainActor class ViewModel: ObservableObject {
        var authenticationService: AuthenticationService

        init(authenticationService: AuthenticationService) {
            self.authenticationService = authenticationService
        }

        @Published var login = ""
        @Published var password = ""
        @Published var email = ""
        @Published var phone = ""

        @Published var activeAlert: ActiveAlert = .success
        @Published var alertMessage: String = ""
        @Published var showAlert = false

        func authorization() {
            authenticationService.view = .authorization
        }

        func register() {
            Task {
                let user = RegistrationCommand(login: login, password: password, email: email, phone: phone)
                let (id, error) = try await NetworkService.shared.postUser(user: user)
                if id != nil {
                    login = ""
                    password = ""
                    email = ""
                    phone = ""
                    alertMessage = "You have successfully registered"
                    activeAlert = .success
                    showAlert.toggle()
                } else {
                    alertMessage = error ?? ""
                    activeAlert = .error
                    showAlert.toggle()
                }
            }
        }

    }
}

enum ActiveAlert {
    case error, success
}
