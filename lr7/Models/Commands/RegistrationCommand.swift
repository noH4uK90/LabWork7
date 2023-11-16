//
//  RegistrationCommand.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation

struct RegistrationCommand: Codable {
    let login: String
    let password: String
    let email: String
    let phone: String
}
