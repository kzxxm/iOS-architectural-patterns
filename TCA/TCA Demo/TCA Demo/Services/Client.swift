//
//  Client.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import Dependencies
import Foundation

// MARK: - Dependency
private enum TodoClientKey: DependencyKey {
    static let liveValue = TodoClient.live
    static let testValue = TodoClient.mock
}

extension DependencyValues {
    var todoClient: TodoClient {
        get { self[TodoClientKey.self] }
        set { self[TodoClientKey.self] = newValue }
    }
}


// MARK: - Client
struct TodoClient: Sendable {
    var loadTodos: @Sendable () async throws -> [Todo]
    var saveTodos: @Sendable ([Todo]) async throws -> Bool
    var deleteTodo: @Sendable (Todo.ID) async throws -> Void
}

extension TodoClient {
    static let live = TodoClient(
        loadTodos: {
            // Load from UserDefaults
            if let data = UserDefaults.standard.data(forKey: "todos"),
               let todos = try? JSONDecoder().decode([TodoData].self, from: data) {
                return todos.map { $0.toDomain() }
            }
            return []
        },
        saveTodos: { todos in
            // Save to UserDefaults 
            let todoData = todos.map { TodoData(from: $0) }
            let data = try JSONEncoder().encode(todoData)
            UserDefaults.standard.set(data, forKey: "todos")
            return true
        },
        deleteTodo: { id in
            // Load current todos, remove the one with matching ID, save back
            if let data = UserDefaults.standard.data(forKey: "todos"),
               let currentTodos = try? JSONDecoder().decode([TodoData].self, from: data) {
                let filteredTodos = currentTodos.filter { $0.id != id.uuidString }
                let newData = try JSONEncoder().encode(filteredTodos)
                UserDefaults.standard.set(newData, forKey: "todos")
            }
        }
    )
    
    static let mock = TodoClient(
        loadTodos: {
            [
                Todo(title: "Learn TCA", isCompleted: false, priority: .high),
                Todo(title: "Build amazing apps", isCompleted: false, priority: .medium),
                Todo(title: "Master SwiftUI", isCompleted: true, priority: .low)
            ]
        },
        saveTodos: { _ in true },
        deleteTodo: { _ in }
    )
}

private struct TodoData: Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let createdAt: Date
    let priority: String
    
    init(from todo: Todo) {
        self.id = todo.id.uuidString
        self.title = todo.title
        self.isCompleted = todo.isCompleted
        self.createdAt = todo.createdAt
        self.priority = todo.priority.rawValue
    }
    
    func toDomain() -> Todo {
        var todo = Todo(id: UUID(uuidString: id) ?? UUID(), title: title)
        todo.isCompleted = isCompleted
        todo.createdAt = createdAt
        todo.priority = Todo.Priority(rawValue: priority) ?? .medium
        return todo
    }
}
