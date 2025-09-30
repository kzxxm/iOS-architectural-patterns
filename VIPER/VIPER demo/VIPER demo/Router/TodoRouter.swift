//
//  TodoRouter.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//


import Foundation

class TodoRouter: TodoRouterProtocol {
    func presentTodoDetail(for todo: TodoEntity, from view: TodoViewProtocol) {
        // In a real app, this would create and present a detail module
        print("Presenting detail for todo: \(todo.title)")
    }
    
    func dismissTodoDetail() {
        // Handle dismissal
        print("Dismissing todo detail")
    }
}
