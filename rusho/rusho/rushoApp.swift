//
//  rushoApp.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct rushoApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
