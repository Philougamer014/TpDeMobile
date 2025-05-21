import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class FriendViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var searchResults: [Friend] = []

    private let db = Firestore.firestore()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    init() {
        Task {
            await loadFriends()
        }
    }

    func loadFriends() async {
        guard let userId = currentUserId else { return }

        do {
            let snapshot = try await db
                .collection("users")
                .document(userId)
                .collection("friends")
                .getDocuments()

            self.friends = snapshot.documents.compactMap { doc in
                let data = doc.data()
                return Friend(
                    id: doc.documentID,
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    username: data["username"] as? String ?? ""
                )
            }
        } catch {
            print("Failed to load friends: \(error.localizedDescription)")
        }
    }

    func addFriend(_ friend: Friend) async {
        guard let userId = currentUserId else { return }

        let data: [String: Any] = [
            "firstName": friend.firstName,
            "lastName": friend.lastName,
            "username": friend.username
        ]

        do {
            try await db
                .collection("users")
                .document(userId)
                .collection("friends")
                .document(friend.id)
                .setData(data)
        } catch {
            print("Failed to add friend: \(error.localizedDescription)")
        }
    }

    func searchUsers(matching searchText: String) async {
        guard let userId = currentUserId else { return }

        do {
           
            let friendsSnapshot = try await db
                .collection("users")
                .document(userId)
                .collection("friends")
                .getDocuments()

            let excludedIds = Set(friendsSnapshot.documents.map { $0.documentID } + [userId])
            let queryText = searchText.lowercased()

            
            let snapshot = try await db
                .collection("users")
                .limit(to: 100)
                .getDocuments()

            self.searchResults = snapshot.documents.compactMap { doc in
                let uid = doc.documentID
                guard !excludedIds.contains(uid) else { return nil }

                let data = doc.data()
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let username = data["username"] as? String ?? ""

                let matches = [firstName, lastName, username].contains { $0.lowercased().contains(queryText) }

                return matches ? Friend(id: uid, firstName: firstName, lastName: lastName, username: username) : nil
            }
        } catch {
            print("Failed to search users: \(error.localizedDescription)")
        }
    }

    func fetchFriend(byId userId: String) async -> Friend? {
        do {
            let doc = try await db.collection("users").document(userId).getDocument()
            guard let data = doc.data() else { return nil }
            return Friend(
                id: userId,
                firstName: data["firstName"] as? String ?? "",
                lastName: data["lastName"] as? String ?? "",
                username: data["username"] as? String ?? ""
            )
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }
}
