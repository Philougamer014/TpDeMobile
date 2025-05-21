import SwiftUI
import FirebaseAuth

struct FriendListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var friendListViewModel = FriendViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Search by username", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Search") {
                    Task {
                        await friendListViewModel.searchUsers(matching: searchText)
                    }
                }

                List {
                    Section(header: Text("Search Results")) {
                        ForEach(friendListViewModel.searchResults) { friend in
                            HStack {
                                Text(friend.username).bold()
                                Text("\(friend.firstName) \(friend.lastName)")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Add") {
                                    Task {
                                        await friendListViewModel.addFriend(friend)
                                    }
                                }
                            }
                        }
                    }

                    Section(header: Text("Friends")) {
                        ForEach(friendListViewModel.friends) { friend in
                            NavigationLink(destination: ChatView(chatPartnerId: friend.id)) {
                                Text(friend.username)
                            }
                        }
                    }
                }

                Button("Disconnect") {
                    authViewModel.logout()
                }
                .padding(.top)
            }
            .task {
                await friendListViewModel.loadFriends()
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}
