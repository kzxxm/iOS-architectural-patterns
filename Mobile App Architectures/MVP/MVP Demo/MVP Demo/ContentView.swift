//
//  ContentView.swift
//  MVP Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import SwiftUI

// MARK: - View
struct ContentView: View {
    @StateObject private var presenter: TodoPresenter
    @State private var newTodoTitle = ""
    
    init() {
        let model = TodoModel()
        self._presenter = StateObject(wrappedValue: TodoPresenter(model: model))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Add new todo section
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: newTodoTitle) { newValue in
                            presenter.didChangeTextInput(newValue)
                        }
                    
                    Button("Add") {
                        presenter.didTapAddButton(with: newTodoTitle)
                        newTodoTitle = ""
                    }
                    .disabled(!presenter.isAddButtonEnabled)
                }
                .padding()
                
                // Stats section
                HStack {
                    Text("Pending: \(presenter.getPendingCount())")
                    Spacer()
                    Text("Completed: \(presenter.getCompletedCount())")
                }
                .padding(.horizontal)
                .font(.caption)
                .foregroundStyle(.secondary)
                
                // Todo list
                List {
                    ForEach(presenter.displayedTodos) { displayItem in
                        HStack {
                            Text(displayItem.displayText)
                                .strikethrough(displayItem.strikethrough)
                                .foregroundStyle(displayItem.textColor)
                            
                            Spacer()
                            
                            Button(displayItem.buttonText) {
                                presenter.didTapToggleButton(for: displayItem.id)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let todoId = presenter.displayedTodos[index].id
                            presenter.didRequestDelete(for: todoId)
                        }
                    }
                }
            }
            .navigationTitle(presenter.navigationTitle)
        }
    }
}

#Preview {
    ContentView()
}
