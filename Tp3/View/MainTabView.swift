import SwiftUI

struct MainTabView: View {
    @StateObject private var characterViewModel = CharacterViewModel()
    @State private var showCharacterCreation = false

    var body: some View {
        TabView {
            MapKitView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            FriendListView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .onAppear {
            Task {
                let hasCharacter = await characterViewModel.checkCharacterExists()
                if !hasCharacter {
                    showCharacterCreation = true
                }
            }
        }
        .fullScreenCover(isPresented: $showCharacterCreation) {
            CreateCharacterView(onCharacterCreated: {
                showCharacterCreation = false
            })
        }
    }
}
