//
//  TodoViewObservable.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import Foundation
import Combine

class TodoViewObservable: TodoViewProtocol, ObservableObject {
    var presenter: TodoPresenterProtocol?
    
    @Published var todos: [TodoEntity] = []
    @Published var newTodoText = ""
    @Published var searchText = ""
    @Published var selectedFilter: TodoFilter = .all
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var pendingCount = 0
    @Published var completedCount = 0
    
    func showTodos(_ todos: [TodoEntity]) {
        DispatchQueue.main.async {
            self.todos = todos
        }
    }
    
    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
    
    func clearNewTodoText() {
        DispatchQueue.main.async {
            self.newTodoText = ""
        }
    }
    
    func updateStats(pending: Int, completed: Int) {
        DispatchQueue.main.async {
            self.pendingCount = pending
            self.completedCount = completed
        }
    }
}
