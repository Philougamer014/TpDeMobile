import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var newMessage: String = ""

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    func listenForMessage(with chatPartnerId: String) {
        guard let currentUserId = userId else { return }

        listener?.remove() 

        listener = db.collection("message")
            .whereField("participants", arrayContains: currentUserId)
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self?.messages = documents.compactMap { doc in
                        let data = doc.data()
                        guard
                            let text = data["text"] as? String,
                            let senderId = data["senderId"] as? String,
                            let receiverId = data["receiverId"] as? String,
                            let timestamp = data["timestamp"] as? Timestamp
                        else {
                            return nil
                        }

        
                        let isBetweenUsers =
                            (senderId == currentUserId && receiverId == chatPartnerId) ||
                            (senderId == chatPartnerId && receiverId == currentUserId)

                        if isBetweenUsers {
                            return ChatMessage(
                                id: doc.documentID,
                                text: text,
                                senderId: senderId,
                                receiverId: receiverId,
                                timestamp: timestamp.dateValue()
                            )
                        } else {
                            return nil
                        }
                    }
                }
            }
    }


    @MainActor
    func sendMessage(to receiverId: String) async {
        guard let senderId = userId else { return }

        do {
            try await db.collection("message").addDocument(data: [
                "text": newMessage,
                "senderId": senderId,
                "receiverId": receiverId,
                "participants": [senderId, receiverId],
                "timestamp": FieldValue.serverTimestamp()
            ])
            newMessage = ""
        } catch {
            print("Error while sending message: \(error.localizedDescription)")
        }
    }
}
