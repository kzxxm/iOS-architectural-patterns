//
//  TodoFilter.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import Foundation

enum TodoFilter: String, CaseIterable, Equatable {
    case all = "All"
    case pending = "Pending"
    case completed = "Completed"
    
    func apply(to todos: [Todo]) -> [Todo] {
        switch self {
        case .all: return todos
        case .pending: return todos.filter { !$0.isCompleted }
        case .completed: return todos.filter { $0.isCompleted }
        }
    }
}
