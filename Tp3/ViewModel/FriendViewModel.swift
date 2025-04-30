//
//  FriendViewModel.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-16.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
@MainActor
class FriendViewModel:ObservableObject {
    @Published var friends: [Friend] = []
    @Published var searchResults: [Friend] = []
    
    private let db = Firestore.firestore()
    
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
    }
    
    func fetchFriends() async {
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
            print("Failed to fetch friends: \(error.localizedDescription)")
        }
    }

    
    var currentUserId:String?{
        Auth.auth().currentUser?.uid
    }
    
    func addFriend(_ friend : Friend)async{
        guard let currentUserId = currentUserId else { return }
        
       db.collection("users").document(currentUserId).collection("friends").document(friend.id).setData( [
            "firstName": friend.firstName,
            "lastname": friend.lastName,
            "username": friend.username
        ]) { error in
            if let error = error {
                print("Firestore error:", error.localizedDescription)
            }
        }
    }
    
    func searchUser(searchText: String) async {
        guard let currentUserId = currentUserId else { return }

        do {
            // Step 1: Get current friend IDs to exclude them
            let friendsSnapshot = try await db.collection("users")
                .document(currentUserId)
                .collection("friends")
                .getDocuments()
            
            let friendIds = friendsSnapshot.documents.map { $0.documentID }

           
            let usersSnapshot = try await db.collection("users")
                .limit(to: 100) 
                .getDocuments()

          
            let lowercasedSearch = searchText.lowercased()
            searchResults = usersSnapshot.documents.compactMap { doc in
                let userId = doc.documentID
                let data = doc.data()
                let username = data["username"] as? String ?? ""

                
                if userId == currentUserId || friendIds.contains(userId) {
                    return nil
                }

            
                if username.lowercased().contains(lowercasedSearch) {
                    return Friend(
                        id: userId,
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        username: username
                    )
                } else {
                    return nil
                }
            }
        } catch {
            print("Failed to search users: \(error.localizedDescription)")
        }
    }



}

//let snapshot = try await db.collection("users")
//                .whereField("username", isEqualTo: searchText)
//                .getDocuments()

