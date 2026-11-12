//
//  TodoListView.swift
//  rusho
//
//  Created by Md Sabbir Hossain on 12/11/26.
//

import SwiftUI

struct TodoListView: View {
    let uid: String
    let onSignOut: () -> Void

    @State private var viewModel = TodoViewModel()
    @State private var showNewTodo = false
    @State private var todoToEdit: Todo?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.todos.isEmpty {
                    ContentUnavailableView(
                        "No Todos Yet",
                        systemImage: "checklist",
                        description: Text("Tap + to add your first task.")
                    )
                } else {
                    todoList
                }
            }
            .navigationTitle("My Todos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out", action: onSignOut)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewTodo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task { viewModel.observe(uid: uid) }
            .onDisappear { viewModel.stopObserving() }
            .sheet(isPresented: $showNewTodo) {
                TodoEditorView(uid: uid, viewModel: viewModel, existing: nil)
            }
            .sheet(item: $todoToEdit) { todo in
                TodoEditorView(uid: uid, viewModel: viewModel, existing: todo)
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var todoList: some View {
        List {
            ForEach(viewModel.todos) { todo in
                HStack(spacing: 12) {
                    Button {
                        Task {
                            do { try await viewModel.toggle(todo, for: uid) }
                            catch { viewModel.errorMessage = error.localizedDescription }
                        }
                    } label: {
                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(todo.isCompleted ? .green : .secondary)
                    }
                    .buttonStyle(.borderless)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(todo.title)
                            .font(.headline)
                            .strikethrough(todo.isCompleted)
                        if !todo.description.isEmpty {
                            Text(todo.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }

                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { todoToEdit = todo }
                .swipeActions(edge: .leading) {
                    Button {
                        Task {
                            do { try await viewModel.toggle(todo, for: uid) }
                            catch { viewModel.errorMessage = error.localizedDescription }
                        }
                    } label: {
                        Label(
                            todo.isCompleted ? "Undo" : "Done",
                            systemImage: todo.isCompleted ? "arrow.uturn.backward" : "checkmark"
                        )
                        .labelStyle(.iconOnly)
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task {
                            do { try await viewModel.delete(todo, for: uid) }
                            catch { viewModel.errorMessage = error.localizedDescription }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
    }
}
