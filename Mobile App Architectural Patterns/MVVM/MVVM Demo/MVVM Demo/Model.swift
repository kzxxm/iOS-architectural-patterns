//
//  Model.swift
//  MVVM Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import Foundation

// MARK: - Model
struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdAt = Date()
}

class TodoModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
    }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
    
    func deleteTodo(withID id: UUID) {
        todos.removeAll { $0.id == id }
    }
    
    func toggleTodo(withID id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
        }
    }
}
