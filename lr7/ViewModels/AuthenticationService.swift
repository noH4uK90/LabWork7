//
//  AuthenticationService.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation

class AuthenticationService: ObservableObject {
    @Published var view: AppViews = .authorization
}

enum AppViews {
    case authorization, registration, users
}
