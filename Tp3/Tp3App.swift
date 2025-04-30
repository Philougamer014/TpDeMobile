//
//  Tp3App.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-16.
//

import SwiftUI
import Firebase

@main
struct Tp3App: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel())
        }
    }
}
