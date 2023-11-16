//
//  User.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let email: String
    let phone: String
}
