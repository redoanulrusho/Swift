//
//  TodoViewModel.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import Foundation
import FirebaseFirestore

/// Handles CRUD for the signed-in user's todos in Firestore.
@Observable
final class TodoViewModel {
    var todos: [Todo] = []
    var errorMessage: String?

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    private func todosRef(for uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("todos")
    }

    // MARK: - Read (live listener)

    func observe(uid: String) {
        guard listener == nil else { return }
        listener = todosRef(for: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                // Firestore invokes listeners on the main queue by default.
                MainActor.assumeIsolated {
                    guard let self else { return }
                    if let error {
                        self.errorMessage = error.localizedDescription
                    } else if let snapshot {
                        self.todos = snapshot.documents.compactMap { try? $0.data(as: Todo.self) }
                    }
                }
            }
    }

    func stopObserving() {
        listener?.remove()
        listener = nil
    }

    // MARK: - Create

    func add(_ todo: Todo, for uid: String) async throws {
        _ = try todosRef(for: uid).addDocument(from: todo)
    }

    // MARK: - Update

    func update(_ todo: Todo, for uid: String) async throws {
        guard let id = todo.id else { return }
        try todosRef(for: uid).document(id).setData(from: todo)
    }

    func toggle(_ todo: Todo, for uid: String) async throws {
        guard let id = todo.id else { return }
        try await todosRef(for: uid).document(id).updateData(["isCompleted": !todo.isCompleted])
    }

    // MARK: - Delete

    func delete(_ todo: Todo, for uid: String) async throws {
        guard let id = todo.id else { return }
        try await todosRef(for: uid).document(id).delete()
    }
}
