//
//  Controller.swift
//  MVC Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import SwiftUI

// MARK: - Controller
class TodoController: ObservableObject {
    @Published var model = TodoModel()
    
    var todos: [TodoItem] {
        model.todos
    }
    
    func addTodo(_ title: String) {
        guard !title.isEmpty else { return }
        model.addTodo(title)
    }
    
    func toggleTodo(at index: Int) {
        model.toggleTodo(at: index)
    }
    
    func deleteTodo(at index: Int) {
        model.deleteTodo(at: index)
    }
}
