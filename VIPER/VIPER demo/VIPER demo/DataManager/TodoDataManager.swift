//
//  TodoDataManager.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//


import Foundation

class TodoDataManager: TodoDataManagerProtocol {
    private var todos: [TodoEntity] = []
    
    func loadTodos() async throws -> [TodoEntity] {
        // Simulate loading delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Return mock data if empty
        if todos.isEmpty {
            todos = [
                TodoEntity(title: "Learn VIPER Architecture", priority: .high),
                TodoEntity(title: "Build Amazing Apps", priority: .medium),
                TodoEntity(title: "Master iOS Development", priority: .low)
            ]
        }
        
        return todos
    }
    
    func saveTodos(_ todos: [TodoEntity]) async throws {
        // Simulate saving delay
        try await Task.sleep(nanoseconds: 500_000_000)
        self.todos = todos
    }
    
    func deleteTodo(id: UUID) async throws {
        // Simulate deletion delay
        try await Task.sleep(nanoseconds: 250_000_000)
        todos.removeAll { $0.id == id }
    }
}
