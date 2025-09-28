//
//  Model.swift
//  MVI Demo
//
//  Created by Kassim Mirza on 28/09/2025.
//

import Combine
import SwiftUI

// MARK: - Model (State)
struct TodoState: Equatable {
    let todos: [TodoItem]
    let newTodoText: String
    let searchText: String
    let filter: TodoFilter
    let isLoading: Bool
    let error: String?
    
    // Computed properties for derived state
    var filteredTodos: [TodoItem] {
        let filtered = filter.apply(to: todos)
        
        if searchText.isEmpty {
            return filtered.sorted { $0.createdAt > $1.createdAt }
        } else {
            return filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var pendingCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    var canAddTodo: Bool {
        !newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    var navigationTitle: String {
        "Todos (\(todos.count))"
    }
    
    var statsText: String {
        "\(pendingCount) pending, \(completedCount) completed"
    }
    
    static let initial = TodoState(
        todos: [],
        newTodoText: "",
        searchText: "",
        filter: .all,
        isLoading: false,
        error: nil
    )
}


// MARK: - Supporting Models
struct TodoItem: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, isCompleted, createdAt
    }
}

enum TodoFilter: CaseIterable, Equatable {
    case all, pending, completed
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .pending: return "Pending"
        case .completed: return "Completed"
        }
    }
    
    func apply(to todos: [TodoItem]) -> [TodoItem] {
        switch self {
        case .all: return todos
        case .pending: return todos.filter { !$0.isCompleted }
        case .completed: return todos.filter { $0.isCompleted }
        }
    }
}
