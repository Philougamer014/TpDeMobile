import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var chatViewModel = ChatViewModel()
    let chatPartnerId: String

    var userId: String? {
        Auth.auth().currentUser?.uid
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatViewModel.messages) { message in
                            HStack {
                                Text(message.text)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                    .frame(maxWidth: .infinity, alignment: message.senderId == userId ? .trailing : .leading)
                            }
                            .id(message.id)
                            .padding(.horizontal)
                        }
                    }
                }
                .onChange(of: chatViewModel.messages.count) { _ in
                    if let last = chatViewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("Message", text: $chatViewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    Task {
                        await chatViewModel.sendMessage(to: chatPartnerId)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            chatViewModel.listenForMessage()
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}
