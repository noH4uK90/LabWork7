//
//  CreateMessageCommand.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation

struct CreateMessageCommand: Codable {
    let textHash: String
    let senderId: Int
    let receiverId: Int
}
