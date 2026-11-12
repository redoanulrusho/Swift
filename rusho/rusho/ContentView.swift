//
//  ContentView.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var auth = AuthViewModel()

    var body: some View {
        if let uid = auth.user?.uid {
            TodoListView(uid: uid, onSignOut: { auth.signOut() })
        } else {
            LoginView(auth: auth)
        }
    }
}

#Preview {
    ContentView()
}
