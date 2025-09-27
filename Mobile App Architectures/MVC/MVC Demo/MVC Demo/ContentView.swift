//
//  ContentView.swift
//  MVC Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import SwiftUI

// MARK: - View
struct ContentView: View {
    @StateObject private var controller = TodoController()
    @State private var newTodoTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Add new todo section
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Add") {
                        controller.addTodo(newTodoTitle)
                        newTodoTitle = ""
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding()
                
                // Todo list
                List {
                    ForEach(Array(controller.todos.enumerated()), id: \.element.id) { index, todo in
                        HStack {
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                            
                            Spacer()
                            
                            Button(todo.isCompleted ? "Undo" : "Complete") {
                                controller.toggleTodo(at: index)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            controller.deleteTodo(at: index)
                        }
                    }
                }
            }
            .navigationTitle("My Todos")
        }
    }
}

#Preview {
    ContentView()
}
