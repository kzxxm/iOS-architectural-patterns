//
//  TodoRowView.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import ComposableArchitecture
import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    let store: StoreOf<TodoReducer>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                TextField(
                    "Todo title",
                    text: .init(
                        get: { todo.title },
                        set: { newValue in
                            store.send(.todoTitleChanged(id: todo.id, title: newValue))
                        }
                    )
                )
                .font(.body)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                
                HStack {
                    Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Picker("Priority", selection: .init(
                        get: { todo.priority },
                        set: { newPriority in
                            store.send(.todoPriorityChanged(id: todo.id, priority: newPriority))
                        }
                    )) {
                        ForEach(Todo.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundStyle(todo.priority.color)
                    .font(.caption)
                }
            }
            
            Spacer()
            
            Button(todo.isCompleted ? "Undo" : "Complete") {
                store.send(.todoToggled(id: todo.id))
            }
            .font(.caption)
            .foregroundStyle(todo.isCompleted ? .orange : .green)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            store.send(.todoToggled(id: todo.id))
        }
    }
}
