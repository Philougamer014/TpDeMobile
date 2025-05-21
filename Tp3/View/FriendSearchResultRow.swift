import SwiftUI

struct FriendSearchResultRow: View {
    let friend: Friend
    let onSendRequest: () -> Void

    @State private var showConfirmation = false

    var body: some View {
        Button(action: {
            showConfirmation = true
        }) {
            HStack {
                Text("\(friend.firstName) \(friend.lastName)")
                Spacer()
            }
            .padding()
        }
        .confirmationDialog(
            "Send friend request to \(friend.firstName)?",
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {
            Button("Send Request", role: .none, action: onSendRequest)
            Button("Cancel", role: .cancel) {}
        }
    }
}
