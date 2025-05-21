//
//  ContentView.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            if authViewModel.isAutentificated {
                MainTabView()
            }else{
                LoginView()
            }
                
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
