//
//  TodoRowAction.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import SwiftUI

enum TodoRowAction {
    case toggle
    case showDetail
}

struct TodoRowView: View {
    let todo: TodoEntity
    let onAction: (TodoRowAction) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Main content - tappable for detail
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .secondary : .primary)
                
                HStack {
                    Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(todo.priority.rawValue)
                        .font(.caption)
                        .foregroundColor(todo.priority.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(todo.priority.color.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                print("TodoRowView: Row tapped for detail - \(todo.title)")
                onAction(.showDetail)
            }
            
            // Action button - completely separate touch area
            Button(action: {
                print("TodoRowView: Button tapped for todo: \(todo.title), isCompleted: \(todo.isCompleted)")
                onAction(.toggle)
            }) {
                Text(todo.isCompleted ? "Undo" : "Complete")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(todo.isCompleted ? Color.orange : Color.green)
                    .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
