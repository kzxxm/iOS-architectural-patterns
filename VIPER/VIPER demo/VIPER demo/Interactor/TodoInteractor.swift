//
//  TodoInteractor.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import Foundation

class TodoInteractor: TodoInteractorProtocol {
    weak var presenter: TodoInteractorOutputProtocol?
    var dataManager: TodoDataManagerProtocol?
    
    private var todos: [TodoEntity] = []
    
    func loadTodos() {
        print("Interactor: Loading todos...")
        Task {
            do {
                let loadedTodos = try await dataManager?.loadTodos() ?? []
                self.todos = loadedTodos
                print("Interactor: Loaded \(loadedTodos.count) todos")
                
                await MainActor.run {
                    presenter?.todosDidLoad(loadedTodos)
                }
            } catch {
                print("Interactor: Error loading todos: \(error)")
                await MainActor.run {
                    presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func addTodo(title: String) {
        print("Interactor: Adding todo with title: \(title)")
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            print("Interactor: Title is empty, not adding")
            return
        }
        
        let newTodo = TodoEntity(title: trimmedTitle)
        todos.append(newTodo)
        print("Interactor: Created new todo: \(newTodo.title)")
        
        Task {
            do {
                try await dataManager?.saveTodos(todos)
                print("Interactor: Successfully saved todos")
                await MainActor.run {
                    presenter?.todoDidAdd(newTodo)
                }
            } catch {
                print("Interactor: Error saving todos: \(error)")
                // Rollback on error
                todos.removeAll { $0.id == newTodo.id }
                await MainActor.run {
                    presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func updateTodo(_ todo: TodoEntity) {
        print("Interactor: Updating todo: \(todo.title), isCompleted: \(todo.isCompleted)")
        
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            print("Interactor: Updated todo in local array")
            
            Task {
                do {
                    try await dataManager?.saveTodos(todos)
                    print("Interactor: Successfully saved updated todo")
                    await MainActor.run {
                        presenter?.todoDidUpdate(todo)
                    }
                } catch {
                    print("Interactor: Error saving updated todo: \(error)")
                    await MainActor.run {
                        presenter?.didFailWithError(error)
                    }
                }
            }
        } else {
            print("Interactor: Warning - Todo not found for update: \(todo.id)")
        }
    }
    
    func deleteTodo(id: UUID) {
        let todoToDelete = todos.first { $0.id == id }
        todos.removeAll { $0.id == id }
        
        Task {
            do {
                try await dataManager?.deleteTodo(id: id)
                await MainActor.run {
                    presenter?.todoDidDelete(id: id)
                }
            } catch {
                // Rollback on error
                if let todo = todoToDelete {
                    todos.append(todo)
                }
                await MainActor.run {
                    presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func clearCompletedTodos() {
        let completedTodos = todos.filter { $0.isCompleted }
        todos.removeAll { $0.isCompleted }
        
        Task {
            do {
                try await dataManager?.saveTodos(todos)
                await MainActor.run {
                    presenter?.todosDidLoad(todos)
                }
            } catch {
                // Rollback on error
                todos.append(contentsOf: completedTodos)
                await MainActor.run {
                    presenter?.didFailWithError(error)
                }
            }
        }
    }
}
