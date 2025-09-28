//
//  Store.swift
//  MVI Demo
//
//  Created by Kassim Mirza on 28/09/2025.
//

import Combine
import SwiftUI

// MARK: - Store (State Container)
class TodoStore: ObservableObject {
    @Published private(set) var state = TodoState.initial
    
    private var cancellables = Set<AnyCancellable>()
    private let todosKey = "SavedTodos"
    
    init() {
        setupSideEffects()
        // Load saved todos on initialization
        loadInitialTodos()
    }
    
    func send(_ intent: TodoIntent) {
        let newState = TodoReducer.reduce(state: state, intent: intent)
        
        // Apply state change on main thread for UI updates
        DispatchQueue.main.async {
            self.state = newState
        }
        
        // Handle side effects
        handleSideEffects(intent: intent, oldState: state, newState: newState)
    }
    
    private func setupSideEffects() {
        // Auto-save todos when they change
        $state
            .map(\.todos)
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .sink { todos in
                self.saveTodos(todos)
            }
            .store(in: &cancellables)
    }
    
    private func handleSideEffects(intent: TodoIntent, oldState: TodoState, newState: TodoState) {
        switch intent {
        case .loadTodos:
            // Load todos from UserDefaults
            DispatchQueue.global().async {
                let savedTodos = self.loadTodos()
                DispatchQueue.main.async {
                    self.send(.todosLoaded(savedTodos))
                }
            }
            
        default:
            break
        }
    }
    
    private func loadInitialTodos() {
        let savedTodos = loadTodos()
        if !savedTodos.isEmpty {
            DispatchQueue.main.async {
                self.state = TodoState(
                    todos: savedTodos,
                    newTodoText: "",
                    searchText: "",
                    filter: .all,
                    isLoading: false,
                    error: nil
                )
            }
        }
    }
    
    private func saveTodos(_ todos: [TodoItem]) {
        do {
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: todosKey)
            print("Successfully saved \(todos.count) todos")
        } catch {
            print("Failed to save todos: \(error.localizedDescription)")
            // Optionally send an error intent
            DispatchQueue.main.async {
                self.send(.errorOccurred("Failed to save todos: \(error.localizedDescription)"))
            }
        }
    }
    
    private func loadTodos() -> [TodoItem] {
        guard let data = UserDefaults.standard.data(forKey: todosKey) else {
            print("No saved todos found")
            return []
        }
        
        do {
            let todos = try JSONDecoder().decode([TodoItem].self, from: data)
            print("Successfully loaded \(todos.count) todos")
            return todos
        } catch {
            print("Failed to load todos: \(error.localizedDescription)")
            // Optionally send an error intent
            DispatchQueue.main.async {
                self.send(.errorOccurred("Failed to load todos: \(error.localizedDescription)"))
            }
            return []
        }
    }
    
    // Method to clear all saved todos
    func clearAllSavedTodos() {
        UserDefaults.standard.removeObject(forKey: todosKey)
        print("Cleared all saved todos")
    }
}
