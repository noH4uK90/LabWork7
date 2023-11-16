//
//  Message.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation

struct MessageResponse: Identifiable, Codable {
    let id: Int
    let textHash: String
    let dateTime: String
    let sender: User
    let receiver: User
}

struct Message: Identifiable, Codable {
    let id: Int
    let text: String
    let dateTime: Date
    let sender: User
    let receiver: User
}
