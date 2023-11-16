//
//  RegistrationView.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import SwiftUI

struct RegistrationView: View {

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
            VStack {
                title
                inputData
                buttons
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                switch viewModel.activeAlert {
                case .error:
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .cancel {viewModel.showAlert.toggle()}
                    )
                case .success:
                    Alert(
                        title: Text("Success"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .cancel {viewModel.showAlert.toggle()}
                    )
                }
            }
        }

        var title: some View {
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 70)
        }

        var inputData: some View {
            VStack {
                TextField("Login", text: $viewModel.login)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)

                TextField("Phone", text: $viewModel.phone)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.vertical)
        }

        var buttons: some View {
            VStack {
                Button("Create account") {
                    viewModel.register()
                }
                .buttonStyle(.borderedProminent)

                Button("Sign in") {
                    viewModel.authorization()
                }
                .font(.callout)
            }
            .padding()
        }
    }
}

#Preview {
    RegistrationView()
}
