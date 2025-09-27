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
    @Published var todos: [TodoItem] = []
    private var model = TodoModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        model.$todos
            .receive(on: DispatchQueue.main)
            .assign(to: &$todos)
    }
    
    func addTodo(_ title: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        model.addTodo(title.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func toggleTodo(at index: Int) {
        model.toggleTodo(at: index)
    }
    
    func deleteTodo(at index: Int) {
        model.deleteTodo(at: index)
    }
}
