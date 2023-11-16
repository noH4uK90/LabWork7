//
//  MessageHasherService.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation
import CryptoSwift

class MessageHasherService: MessageHasherProtocol {

    static let shared = MessageHasherService(); private init() {}

    private static let key = "AGiCViwGU5ERsXmZa67G+5XEWT422LBkRI5BiD9Z0HQ="
    private static let ivKey = "n5bngzYrwII8huM63oLjcg=="

    func encrypt(string: String) throws -> String {
        do {
            let aes = try AES(
                key: Array(base64: MessageHasherService.key),
                blockMode: CBC(iv: Array(base64: MessageHasherService.ivKey))
            )
            let encrypted = try aes.encrypt(string.bytes)
            print("encrypted - \(encrypted)")
            print("encrypted string - \(encrypted.toBase64())")
            return encrypted.toBase64()
        } catch let decryptionError as CryptoSwift.AES.Error {
            print("CryptoSwift AES Error: \(decryptionError)")
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    func decrypt(bytes: String) throws -> String {
        let aes = try AES(
            key: Array(base64: MessageHasherService.key),
            blockMode: CBC(iv: Array(base64: MessageHasherService.ivKey))
        )
        let decrypted = try aes.decrypt(Array(base64: bytes))
        let result = String(data: Data(decrypted), encoding: .utf8) ?? ""
        return result
    }
}
