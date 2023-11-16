//
//  ContentView.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import SwiftUI

struct AuthorizationView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject var notificationService: NotificationService
    var body: some View {
        Content(authenticationService, notificationService)
    }
    struct Content: View {
        @StateObject var viewModel: ViewModel
        init(_ authenticationService: AuthenticationService, _ notificationService: NotificationService) {
            _viewModel = StateObject(wrappedValue: ViewModel(authenticationService: authenticationService,
                                                             notificationService: notificationService))
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
                        dismissButton: .cancel {viewModel.showAlert = false}
                    )
                case .success:
                    Alert(
                        title: Text("Success"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .cancel {viewModel.showAlert = false}
                    )
                }
            }
            .sheet(isPresented: $viewModel.isForgotPassword, content: {
                VStack {
                    TextField("Phone", text: $viewModel.phone)
                        .textFieldStyle(.roundedBorder)

                    Button("Get code") {
                        viewModel.forgotPassword()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            })
        }

        var title: some View {
            Text("Authorization")
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
            }
            .padding(.vertical)
        }

        var buttons: some View {
            VStack {
                HStack {
                    Button(action: {viewModel.auth()}, label: {Text("Sign in")})
                    .buttonStyle(.borderedProminent)

                    Spacer()
                        .frame(maxWidth: 15)

                    Button("Sign up") {
                        viewModel.register()
                    }
                }
                Button("Forget password?") {
                    viewModel.isForgotPassword.toggle()
                }
                .font(.footnote)
            }
            .padding()
        }
    }
}

#Preview {
    AuthorizationView()
        .environmentObject(AuthenticationService())
}
