//
//  TodoEntity.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import SwiftUI
import Foundation

struct TodoEntity {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var priority: Priority
    
    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
    
    init(title: String, priority: Priority = .medium) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
        self.priority = priority
    }
}

// Equatable conformance
extension TodoEntity: Equatable {
    static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

// Hashable conformance
extension TodoEntity: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
