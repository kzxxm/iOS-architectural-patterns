//
//  Todo.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import Foundation
import SwiftUI

struct Todo: Equatable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted = false
    var createdAt = Date()
    var priority: Priority = .medium
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, priority: Priority = .medium) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
    }
    
    enum Priority: String, CaseIterable, Equatable {
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
}
