//
//  MessageHasherProtocol.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation

protocol MessageHasherProtocol {
    func encrypt(string: String) throws -> String
    func decrypt(bytes: String) throws -> String
}
