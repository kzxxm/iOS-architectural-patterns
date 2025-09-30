//
//  ViewModel.swift
//  MVVM Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import Foundation

// MARK: - ViewModel
class TodoViewModel: ObservableObject {
    
    // MARK: - Published Properties (View binds to these)
    @Published var todos: [TodoItem] = []
    @Published var newTodoText = ""
    @Published var searchText = ""
    @Published var showingOnlyIncomplete = false
    
    
    // MARK: - Computed Properties for View
    var filteredTodos: [TodoItem] {
        let filtered = showingOnlyIncomplete ? todos.filter { !$0.isCompleted } : todos
        
        if searchText.isEmpty {
            return filtered.sorted { $0.createdAt > $1.createdAt }
        } else {
            return filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var completedCount: Int {
        todos.filter {$0.isCompleted }.count
    }
    
    var pendingCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    var totalCount: Int {
        todos.count
    }
    
    var canAddTodo: Bool {
        !newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var navigationTitle: String {
        "Todos (\(totalCount)"
    }
    
    var statsText: String {
        "\(pendingCount) pending, \(completedCount) completed"
    }
    
    var filterButtonText: String {
        showingOnlyIncomplete ? "Show All" : "Show Pending"
    }
    
    
    // MARK: - Private Properties
    private let model: TodoModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialisation
    init(model: TodoModel = TodoModel()) {
        self.model = model
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind model changes to ViewModel
        model.$todos
            .assign(to: \.todos, on: self)
            .store(in: &cancellables)
    }
    
    
    // MARK: - Commands/Actions (View calls these)
    func addTodo() {
        let trimmedText = newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newTodo = TodoItem(title: trimmedText)
        model.addTodo(newTodo)
        newTodoText = "" // Clear input field
    }
    
    func toggleTodo(_ todo: TodoItem) {
        model.toggleTodo(withID: todo.id)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        model.deleteTodo(withID: todo.id)
    }
    
    func deleteTodos(at indexSet: IndexSet) {
        let todosToDelete = indexSet.map { filteredTodos[$0] }
        todosToDelete.forEach { model.deleteTodo(withID: $0.id) }
    }
    
    func toggleFilter() {
        showingOnlyIncomplete.toggle()
    }
    
    func clearCompleted() {
        let completedTodos = todos.filter { $0.isCompleted }
        completedTodos.forEach { model.deleteTodo(withID: $0.id) }
    }
    
    func clearSearch() {
        searchText = ""
    }
}
