//
//  Model.swift
//  MVP Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import SwiftUI

// MARK: - Model
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

class TodoModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
    }
    
    func updateTodo(at index: Int, with updatedTodo: TodoItem) {
        guard index < todos.count else { return }
        todos[index] = updatedTodo
    }
    
    func deleteTodo(at index: Int) {
        guard index < todos.count else { return }
        todos.remove(at: index)
    }
}


// MARK: - View Protocol
protocol TodoViewProtocol: ObservableObject {
    var displayedTodos: [TodoDisplayItem] { get set }
    var isAddButtonEnabled: Bool { get set }
    var navigationTitle: String { get set }
}

// MARK: - Disply Models (What the View actually shows)
struct TodoDisplayItem: Identifiable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    let displayText: String
    let textColor: Color
    let strikethrough: Bool
    let buttonText: String
}
