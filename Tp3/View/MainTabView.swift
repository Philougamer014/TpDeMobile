import SwiftUI

struct MainTabView: View {
    @StateObject private var characterViewModel = CharacterViewModel()
    @State private var showCharacterCreation = false

    var body: some View {
        TabView {
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            MapKitView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            FriendListView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
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
