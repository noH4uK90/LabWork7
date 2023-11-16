//
//  lr7App.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import SwiftUI

@main
struct Lr7App: App {
    @StateObject var authenticationService = AuthenticationService()
    @StateObject var notificationService = NotificationService()
    var body: some Scene {
        WindowGroup {
            switch authenticationService.view {
            case .authorization:
                AuthorizationView()
                    .environmentObject(authenticationService)
                    .environmentObject(notificationService)
            case .registration:
                RegistrationView()
                    .environmentObject(authenticationService)
            case .users:
                UsersView()
                    .environmentObject(authenticationService)
            }
        }
    }
}
