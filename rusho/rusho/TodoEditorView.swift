//
//  TodoEditorView.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import SwiftUI

/// Sheet used to create a new todo or edit/delete an existing one.
struct TodoEditorView: View {
    @Environment(\.dismiss) private var dismiss

    let uid: String
    @Bindable var viewModel: TodoViewModel
    let existing: Todo?

    @State private var title = ""
    @State private var description = ""
    @State private var isCompleted = false
    @State private var errorMessage: String?

    private var isEditing: Bool { existing != nil }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...6)
                if isEditing {
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle(isEditing ? "Edit Todo" : "New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
            .onAppear { loadExisting() }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func loadExisting() {
        guard let todo = existing else { return }
        title = todo.title
        description = todo.description
        isCompleted = todo.isCompleted
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Title cannot be empty."
            return
        }

        Task {
            do {
                if let existing {
                    var updated = existing
                    updated.title = trimmedTitle
                    updated.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
                    updated.isCompleted = isCompleted
                    try await viewModel.update(updated, for: uid)
                } else {
                    let todo = Todo(
                        title: trimmedTitle,
                        description: description.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    try await viewModel.add(todo, for: uid)
                }
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
