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

                if user != nil {
                    self.storeToken()
                    await self.syncUserWithApi()
                }
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
            } else {
                self.storeToken()

                Task {
                    await self.syncUserWithApi()
                }
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
                "email": email
            ]) { error in
                if let error = error {
                    print("Firestore error:", error.localizedDescription)
                }
            }

            self.storeToken()
            Task{
                await self.syncUserWithApi()
            }
        }
    }

    private func storeToken() {
        Auth.auth().currentUser?.getIDToken(completion: { token, error in
            if let token = token {
                let success = TokenHandler.saveToken(token: token)
                print(success ? "Token saved to Keychain." : "Failed to save token.")
            } else {
                print("Failed to get token: \(String(describing: error?.localizedDescription)) ?? \"Unknown error\")")
            }
        })
    }
    
    @MainActor
    func syncUserWithApi() async {
        guard let name = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email else { return }

        let dto = SyncUserDTO(name: name)
        do {
            let _: SuccessMessage? = try await Services().postRequestWithToken(endpoint: "mapventure/sync-user", dto: dto)
            print("User synced with API")
        } catch {
            print("Failed to sync user: \(error)")
        }
    }


}
