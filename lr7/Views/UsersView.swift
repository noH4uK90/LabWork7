//
//  UsersView.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import SwiftUI

struct UsersView: View {

    @EnvironmentObject var authenticationService: AuthenticationService

    var body: some View {
        Content(authenticationService: authenticationService)
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel

        init(authenticationService: AuthenticationService) {
            _viewModel = StateObject(wrappedValue: ViewModel(authenticationService: authenticationService))
        }

        var body: some View {
            NavigationStack {
                List {
                    ForEach(viewModel.users, id: \.id) { user in
                        NavigationLink(user.login, value: user)
                    }
                }
                .refreshable(action: { viewModel.fetchUsers() })
                .navigationDestination(for: User.self, destination: ChatView.init)
                .navigationTitle("Users")
            }
        }
    }
}

#Preview {
    UsersView()
}
