//
//  LoginView.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import SwiftUI

struct LoginView: View {
    @Bindable var auth: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "checklist")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)

                Text("Firebase Todo")
                    .font(.largeTitle.bold())

                Form {
                    Picker("Mode", selection: $auth.isSignUpMode) {
                        Text("Sign In").tag(false)
                        Text("Sign Up").tag(true)
                    }
                    .pickerStyle(.segmented)

                    TextField("Email", text: $auth.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    SecureField("Password", text: $auth.password)

                    if auth.isSignUpMode {
                        SecureField("Confirm Password", text: $auth.confirmPassword)
                    }

                    Button {
                        Task { await auth.submit() }
                    } label: {
                        if auth.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text(auth.isSignUpMode ? "Create Account" : "Sign In")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(auth.isLoading)
                }
            }
            .navigationTitle("Welcome")
            .alert(
                "Error",
                isPresented: Binding(
                    get: { auth.errorMessage != nil },
                    set: { if !$0 { auth.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(auth.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    LoginView(auth: AuthViewModel())
}
