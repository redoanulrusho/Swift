//
//  AuthViewModel.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import Foundation
import FirebaseAuth

/// Handles Firebase Authentication (email + password).
@Observable
final class AuthViewModel {
    private(set) var user: FirebaseAuth.User?

    // Form state
    var email = ""
    var password = ""
    var confirmPassword = ""
    var isSignUpMode = false
    var isLoading = false
    var errorMessage: String?

    var isAuthenticated: Bool { user != nil }

    init() {
        // Firebase keeps the session between launches; restore it if present.
        user = Auth.auth().currentUser
    }

    func submit() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in both email and password."
            return
        }
        if isSignUpMode && password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result: AuthDataResult
            if isSignUpMode {
                result = try await Auth.auth().createUser(withEmail: trimmedEmail, password: password)
            } else {
                result = try await Auth.auth().signIn(withEmail: trimmedEmail, password: password)
            }
            user = result.user
            email = ""
            password = ""
            confirmPassword = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
