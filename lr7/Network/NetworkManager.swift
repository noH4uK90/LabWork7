//
//  NetworkManager.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import Foundation

enum Endpoints {
    case code(String)
    case getUsers (Int)
    case getMessage (Int, Int)
    case login, postMessage, postUser

    var baseURL: URL { URL(string: "http://localhost:8085/api")! }

    func path() -> String {
        switch self {
        case .code:
            return "/auth/code"
        case .login:
            return "auth/login"
        case .getUsers:
            return "/user"
        case .postUser:
            return "/user"
        case .getMessage:
            return "/message"
        case .postMessage:
            return "/message"
        }
    }

    var absolutePath: URL? {
        let queryURL = baseURL.appending(path: self.path())
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else {
            return nil
        }

        switch self {
        case .code(let phone):
            urlComponents.queryItems = [URLQueryItem(name: "phone", value: phone)]
        case .getUsers(let id):
            urlComponents.queryItems = [URLQueryItem(name: "meId", value: "\(id)")]
        case .getMessage(let interlocutorId, let meId):
            urlComponents.queryItems = [URLQueryItem(name: "interlocutorId", value: "\(interlocutorId)"),
                                        URLQueryItem(name: "meId", value: "\(meId)")
                                        ]
        case .login:
            urlComponents.queryItems = []
        case .postMessage:
            urlComponents.queryItems = []
        case .postUser:
            urlComponents.queryItems = []
        }

        return urlComponents.url
    }
}
