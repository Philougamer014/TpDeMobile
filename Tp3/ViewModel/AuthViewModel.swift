import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAutentificated = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listenToAuthState()
    }

    private func listenToAuthState() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                guard let self = self else { return }
                self.user = user
                self.isAutentificated = (user != nil)
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Login error:", error.localizedDescription)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout error:", error.localizedDescription)
        }
    }

    func signup(email: String, password: String, username: String, lastname: String, firstname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Signup error:", error.localizedDescription)
                return
            }

            guard let result = result else {
                print("Unexpected error during signup.")
                return
            }

            let uid = result.user.uid
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "username": username,
                "lastname": lastname,
                "firstname": firstname,
                "email":email
            ]) { error in
                if let error = error {
                    print("Firestore error:", error.localizedDescription)
                }
            }
        }
    }
}
