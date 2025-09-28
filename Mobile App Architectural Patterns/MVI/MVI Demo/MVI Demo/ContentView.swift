//
//  ContentView.swift
//  MVI Demo
//
//  Created by Kassim Mirza on 28/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = TodoStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                addTodoSection
                
                searchSection
                
                filterSection
                
                statsSection
                
                todoList
                
                if store.state.isLoading {
                    loadingView
                }
                
                if let error = store.state.error {
                    errorView(error)
                }
            }
            .navigationTitle(store.state.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear Completed") {
                        store.send(.clearCompleted)
                    }
                    .disabled(store.state.completedCount == 0)
                }
            }
        }
        .onAppear {
            store.send(.loadTodos)
        }
    }
    
    // MARK: - View Components
    private var addTodoSection: some View {
        HStack {
            TextField("Enter new todo...", text: Binding(
                get: { store.state.newTodoText },
                set: { newText in
                    store.send(.updateNewTodoText(newText))
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onSubmit {
                store.send(.addTodo)
            }
            
            Button("Add") {
                store.send(.addTodo)
            }
            .disabled(!store.state.canAddTodo)
        }
        .padding()
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search todos...", text: Binding(
                get: { store.state.searchText },
                set: { newText in
                    store.send(.updateSearchText(newText))
                }
            ))
            
            if !store.state.searchText.isEmpty {
                Button("Clear") {
                    store.send(.updateSearchText(""))
                }
                .font(.caption)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    private var filterSection: some View {
        Picker("Filter", selection: Binding(
            get: { store.state.filter },
            set: { newFilter in
                store.send(.setFilter(newFilter))
            }
        )) {
            ForEach(TodoFilter.allCases, id: \.self) { filter in
                Text(filter.displayName).tag(filter)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    private var statsSection: some View {
        Text(store.state.statsText)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.vertical, 8)
    }

    private var todoList: some View {
        List {
            ForEach(store.state.filteredTodos) { todo in
                TodoRowView(todo: todo) { intent in
                    store.send(intent)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let todo = store.state.filteredTodos[index]
                    store.send(.deleteTodo(todo.id))
                }
            }
        }
    }
    
    private var loadingView: some View {
        HStack {
            ProgressView()
            Text("Loading todos...")
        }
        .padding()
    }
    
    private func errorView(_ error: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text(error)
        }
        .foregroundColor(.red)
        .padding()
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let sendIntent: (TodoIntent) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                
                Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
                
            Spacer()
            
            Button(todo.isCompleted ? "Undo" : "Complete") {
                sendIntent(.toggleTodo(todo.id))
            }
            .font(.caption)
            .foregroundStyle(todo.isCompleted ? .orange : .green)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            sendIntent(.toggleTodo(todo.id))
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
