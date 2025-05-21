//
//  LoginView.swift
//  Tp3
//
//  Created by Philippe Léonard on 2025-04-16.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var signup = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userName: String = ""
    

    var body: some View {
        Text(signup ? "Create an acount" : "Login")
        

        VStack() {
            if signup {
                TextField("firstName", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("lastName", text:  $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("userName", text:  $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(signup ?"signup" : "Login") {
                if signup {
                    viewModel.signup(email: email, password: password, username: userName, lastname: lastName, firstname: firstName)
                } else{
                    viewModel.login(email: email, password: password)
                }
                
            }
            Button(signup ? "login" : "signup"){
                if signup {
                    signup = false
                } else {
                    signup = true
                }
            }
        }
        .padding()
    }
}
