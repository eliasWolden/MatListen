//
//  LoginView.swift
//  MatListen
//
//  Created by Elias Wolden on 19/06/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @State private var loggedInUser: User?
    
    var body: some View {
        VStack {
            Text("Login")
                .customFont(size: 30, weight: .bold)
                .padding(.bottom, 50)
            InputField(placeholder: "username", text: $username)
            InputField(placeholder: "password", text: $password)
            
            if let error = loginError {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            
            Button(action: {
                authenticate()
            }) {
                Text("Login")
            }
            .padding()
        }
        .padding()
        .fullScreenCover(item: $loggedInUser) { user in
            TabBarView(user: .constant(user)) // Present the TabBarView
        }
    }
    
    private func authenticate() {
        let lowercasedUsername = username.lowercased()
        let lowercasedPassword = password.lowercased()
        
        let userService = UserService()
        userService.authenticateUser(username: lowercasedUsername, password: lowercasedPassword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.loggedInUser = user // Update the state to trigger presentation
                    print("User logged in: \(user)")
                case .failure(let error):
                    loginError = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct InputField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
            .padding(.bottom, 10)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
