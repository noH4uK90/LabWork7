//
//  NetworkService.swift
//  lr7
//
//  Created by Иван Спирин on 11/14/23.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService(); private init() {}
    private let messageHasherService = MessageHasherService.shared

    func getCode(phone: String) async throws -> (UUID?, String?) {
        guard let url = Endpoints.code(phone).absolutePath else {
            throw APIError.invalidRequestError("code")
        }

        let response = try await URLSession.shared.data(from: url)
        guard let urlResponse = response.1 as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if (200..<300) ~= urlResponse.statusCode {
            let result = try JSONDecoder().decode(UUID.self, from: response.0)
            return (result, nil)
        }
        return (nil, "Invalid phone number")
    }

    func login(user: LoginCommand) async throws -> (User?, String?) {
        guard let url = Endpoints.login.absolutePath else {
            throw APIError.invalidRequestError("login")
        }

        let jsonUser = try JSONEncoder().encode(user)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonUser

        let response = try await URLSession.shared.data(for: request)
        guard let urlResponse = response.1 as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if (200..<300) ~= urlResponse.statusCode {
            let result = try JSONDecoder().decode(User.self, from: response.0)
            return (result, nil)
        }
        let result = try JSONDecoder().decode(String.self, from: response.0)
        return (nil, result)
    }

    func getUsers(id: Int) async throws -> [User] {
        guard let url = Endpoints.getUsers(id).absolutePath else {
            throw APIError.invalidRequestError("users")
        }

        let response = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode([User].self, from: response.0)
        return result
    }

    func postUser(user: RegistrationCommand) async throws -> (Int?, String?) {
        guard let url = Endpoints.postUser.absolutePath else {
            throw APIError.invalidRequestError("user")
        }

        let jsonUser = try JSONEncoder().encode(user)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonUser

        let response = try await URLSession.shared.data(for: request)
        guard let urlResponse = response.1 as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if (200..<300) ~= urlResponse.statusCode {
            let result = try JSONDecoder().decode(Int.self, from: response.0)
            return (result, nil)
        }
        let result = try JSONDecoder().decode(String.self, from: response.0)
        return (nil, result)
    }

    func getMessages(interlocutorId: Int, meId: Int) async throws -> [Message] {
        guard let url = Endpoints.getMessage(interlocutorId, meId).absolutePath else {
            throw APIError.invalidRequestError("get message")
        }

        let response = try await URLSession.shared.data(from: url)
        let messageResponse = try JSONDecoder().decode([MessageResponse].self, from: response.0)
        let messages = try messageResponse.map { response in
            let decryptedText = try self.messageHasherService.decrypt(bytes: response.textHash)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            return Message(
                id: response.id,
                text: decryptedText,
                dateTime: dateFormatter.date(from: response.dateTime) ?? Date.now,
                sender: response.sender,
                receiver: response.receiver
            )
        }

        return messages
    }

    func postMessage(message: CreateMessageCommand) async throws -> Int {
        guard let url = Endpoints.postMessage.absolutePath else {
            throw APIError.invalidRequestError("post message")
        }

        let jsonMessage = try JSONEncoder().encode(message)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonMessage

        let response = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(Int.self, from: response.0)
        return result
    }
}

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)

  /// Indicates an error on the transport layer, e.g. not being able to connect to the server
  case transportError(Error)

  /// Received an invalid response, e.g. non-HTTP result
  case invalidResponse

  /// Server-side validation error
  case validationError(String)

  /// The server sent data in an unexpected format
  case decodingError(Error)

  var errorDescription: String? {
    switch self {
    case .invalidRequestError(let message):
      return "Invalid request: \(message)"
    case .transportError(let error):
      return "Transport error: \(error)"
    case .invalidResponse:
      return "Invalid response"
    case .validationError(let reason):
      return "Validation Error: \(reason)"
    case .decodingError:
      return "The server returned data in an unexpected format. Try updating the app."
    }
  }
}
