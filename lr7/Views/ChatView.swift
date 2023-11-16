//
//  ChatView.swift
//  lr7
//
//  Created by Иван Спирин on 11/13/23.
//

import SwiftUI

struct ChatView: View {

    @StateObject var viewModel: ViewModel
    @State var receiver: User

    init(receiver: User) {
        _viewModel = StateObject(wrappedValue: ViewModel(receiver: receiver))
        self.receiver = receiver
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.messages.reversed()) { message in
                    createMessage(
                        message: message.text,
                        date: message.dateTime,
                        isCurrentUser: viewModel.sender.id == message.sender.id
                    )
                    .scaleEffect(x: 1, y: -1, anchor: .center)
                }
                .listRowSeparator(.hidden)
            }
            .scaleEffect(x: 1, y: -1, anchor: .center)
            .listStyle(.inset)
            HStack {
                TextField("Message...", text: $viewModel.message)
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .disabled(viewModel.message.isEmpty)
            }
            .padding()
        }
        .padding(.top)
        .refreshable {
            viewModel.fetchMessages()
        }
    }

    func createMessage(message: String, date: Date, isCurrentUser: Bool) -> some View {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: date)

        return HStack(alignment: .bottom, spacing: 15) {
            if isCurrentUser {
                Spacer()
            }
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message)
                    .padding(10)
                    .frame(minWidth: 65)
                    .foregroundColor(isCurrentUser ? Color.white : Color.black)
                    .background(
                        isCurrentUser ?
                            Color.blue.gradient :
                            Color(
                                UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                            )
                            .gradient
                    )
                    .cornerRadius(30)
                Text(formattedDate)
                    .font(.caption2)
                    .foregroundStyle(.placeholder)
            }
        }
    }
}

// #Preview {
//    ChatView()
// }
