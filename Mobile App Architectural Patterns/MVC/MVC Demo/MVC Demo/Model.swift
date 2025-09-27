//
//  Model.swift
//  MVC Demo
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
    
    func addTodo(_ title: String) {
        let newTodo = TodoItem(title: title)
        todos.append(newTodo)
    }
    
    func toggleTodo(at index: Int) {
        guard index < todos.count else { return }
        todos[index].isCompleted.toggle()
    }
    
    func deleteTodo(at index: Int) {
        guard index < todos.count else { return }
        todos.remove(at: index)
    }
}
