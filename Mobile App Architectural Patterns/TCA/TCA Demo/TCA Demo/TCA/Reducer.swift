//
//  Reducer.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct TodoReducer: Reducer {
    struct State: Equatable {
        var todos: IdentifiedArrayOf<Todo> = []
        var newTodoText = ""
        var searchText = ""
        var filter: TodoFilter = .all
        var isLoading = false
        var alert: AlertState<Action.Alert>?
        
        var filteredTodos: IdentifiedArrayOf<Todo> {
            let filtered = filter.apply(to: Array(todos))
            
            if searchText.isEmpty {
                return IdentifiedArray(uniqueElements: filtered.sorted { $0.createdAt > $1.createdAt })
            } else {
                let searchFiltered = filtered.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText)
                }
                return IdentifiedArray(uniqueElements: searchFiltered.sorted { $0.createdAt > $1.createdAt })
            }
        }
        
        var completedCount: Int {
            todos.filter { $0.isCompleted }.count
        }
        
        var pendingCount: Int {
            todos.filter { !$0.isCompleted }.count
        }
        
        var canAddTodo: Bool {
            !newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
        }
    }
    
    enum Action {
        case addTodoButtonTapped
        case newtodoTextChanged(String)
        case todoToggled(id: Todo.ID)
        case todoDeleted(id: Todo.ID)
        case searchTextChanged(String)
        case filterChanged(TodoFilter)
        case clearCompletedButtonTapped
        case loadTodos
        case todosLoaded(Result<[Todo], Error>)
        case saveTodos
        case todosSaved(Result<Bool, Error>)
        case alertDismissed
        case todoPriorityChanged(id: Todo.ID, priority: Todo.Priority)
        case todoTitleChanged(id: Todo.ID, title: String)
        
        enum Alert: Equatable {
            case confirmOkay
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .addTodoButtonTapped:
                let trimmedText = state.newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedText.isEmpty else { return .none }
                
                var newTodo = Todo(title: trimmedText)
                newTodo.createdAt = date()
                newTodo.priority = .medium
                
                state.todos.append(newTodo)
                state.newTodoText = ""
                
                return .run { send in
                    try await clock.sleep(for: .seconds(1))
                    await send(.saveTodos)
                }
                
            case let .newtodoTextChanged(text):
                state.newTodoText = text
                return .none
                
            case let .todoToggled(id):
                state.todos[id: id]?.isCompleted.toggle()
                return .run { send in
                    try await clock.sleep(for: .milliseconds(500))
                    await send(.saveTodos)
                }
                
            case let .todoPriorityChanged(id, priority):
                state.todos[id: id]?.priority = priority
                return .run { send in
                    try await clock.sleep(for: .seconds(1))
                    await send(.saveTodos)
                }
                
            case let .todoTitleChanged(id, title):
                state.todos[id: id]?.title = title
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.saveTodos)
                }
                
            case let .todoDeleted(id):
                state.todos.remove(id: id)
                return .run { [todos = state.todos] send in
                    async let saveEffect: Void = {
                        try await clock.sleep(for: .milliseconds(500))
                        await send(.saveTodos)
                    }()
                    
                    async let deleteEffect: Void = {
                        try await todoClient.deleteTodo(id)
                    }()
                    
                    _ = try await (saveEffect, deleteEffect)
                }
                
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
                
            case let .filterChanged(filter):
                state.filter = filter
                return .none
                
            case .clearCompletedButtonTapped:
                let completedIds = state.todos.filter(\.isCompleted).map(\.id)
                state.todos.removeAll { $0.isCompleted }
                
                return .run { send in
                    await send(.saveTodos)
                    
                    for id in completedIds {
                        try await todoClient.deleteTodo(id)
                    }
                }
                
            case .loadTodos:
                state.isLoading = true
                return .run { send in
                    await send(.todosLoaded(Result {
                        try await todoClient.loadTodos()
                    }))
                }
                
            case let .todosLoaded(.success(todos)):
                state.isLoading = false
                state.todos = IdentifiedArray(uniqueElements: todos)
                return .none
                
            case let .todosLoaded(.failure(error)):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("Error")
                } actions: {
                    ButtonState(action: .confirmOkay) {
                        TextState("OK")
                    }
                } message: {
                    TextState("Failed to load todos: \(error.localizedDescription)")
                }
                return .none
                
            case .saveTodos:
                return .run { [todos = state.todos] send in
                    await send(.todosSaved(Result {
                        try await todoClient.saveTodos(Array(todos))
                    }))
                }
                
            case let .todosSaved(.success(success)):
                if !success {
                    state.alert = AlertState {
                        TextState("Error")
                    } actions: {
                        ButtonState(action: .confirmOkay) {
                            TextState("OK")
                        }
                    } message: {
                        TextState("Failed to save todos")
                    }
                }
                return .none
                
            case let .todosSaved(.failure(error)):
                state.alert = AlertState {
                    TextState("Error")
                } actions: {
                    ButtonState(action: .confirmOkay) {
                        TextState("OK")
                    }
                } message: {
                    TextState("Failed to save todos: \(error.localizedDescription)")
                }
                return .none
                
            case .alertDismissed:
                state.alert = nil
                return .none
            }
        }
    }
}
