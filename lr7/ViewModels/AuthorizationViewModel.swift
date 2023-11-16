//
//  AuthorizationViewModel.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation
import UserNotifications

extension AuthorizationView {
    @MainActor class ViewModel: ObservableObject {
        var authenticationService: AuthenticationService
        let notificationService: NotificationService

        init(authenticationService: AuthenticationService, notificationService: NotificationService) {
            self.authenticationService = authenticationService
            self.notificationService = notificationService
            notificationService.askPermission()
        }

        @Published var login = ""
        @Published var password = ""

        @Published var phone = ""
        @Published var isForgotPassword = false
        @Published var isNeedSendNotify = false

        @Published var activeAlert: ActiveAlert = .success
        @Published var alertMessage: String = ""
        @Published var showAlert = false

        func register() {
            authenticationService.view = .registration
        }

        func auth() {
            Task {
                let loginCommand = LoginCommand(login: login, password: password)
                let (user, error) = try await NetworkService.shared.login(user: loginCommand)
                if user != nil {
                    let jsonUser = try JSONEncoder().encode(user)
                    UserDefaults.standard.setValue(jsonUser, forKey: "currentUser")
                    authenticationService.view = .users
                } else {
                    alertMessage = error ?? ""
                    activeAlert = .error
                    showAlert.toggle()
                }
            }
        }

        func forgotPassword() {
            Task {
                let (code, error) = try await NetworkService.shared.getCode(phone: phone)
                print("code - \(code?.uuidString ?? "")")
                print("error - \(error ?? "")")
                if code != nil {
                    let title = "Password code"
                    let body = "Your code for recover password: \(code?.uuidString ?? "")"
                    notificationService.sendNotification(title: title, body: body, timeInterval: 5)
                    phone = ""
                    isForgotPassword = false
                } else {
                    isForgotPassword = false
                    phone = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.alertMessage = error ?? ""
                        self.activeAlert = .error
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
