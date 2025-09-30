//
//  Intent.swift
//  MVI Demo
//
//  Created by Kassim Mirza on 28/09/2025.
//

import Combine
import SwiftUI

// MARK: - Intent
enum TodoIntent {
    case addTodo
    case updateNewTodoText(String)
    case toggleTodo(UUID)
    case deleteTodo(UUID)
    case updateSearchText(String)
    case setFilter(TodoFilter)
    case clearCompleted
    case loadTodos
    case todosLoaded([TodoItem])
    case errorOccurred(String)
}
