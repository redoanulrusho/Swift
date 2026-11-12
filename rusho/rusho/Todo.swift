//
//  Todo.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import Foundation
import FirebaseFirestore

/// A single todo item stored in Firestore under `users/{uid}/todos`.
struct Todo: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date

    init(id: String? = nil, title: String, description: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
