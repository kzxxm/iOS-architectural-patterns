//
//  Reducer.swift
//  MVI Demo
//
//  Created by Kassim Mirza on 28/09/2025.
//

import Combine
import Foundation

// MARK: Reducer
class TodoReducer {
    static func reduce(state: TodoState, intent: TodoIntent) -> TodoState {
        switch intent {
            
        case .updateNewTodoText(let text):
            return TodoState(
                todos: state.todos,
                newTodoText: text,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .addTodo:
            let trimmedText = state.newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedText.isEmpty else { return state }
            
            let newTodo = TodoItem(title: trimmedText)
            return TodoState(
                todos: state.todos + [newTodo],
                newTodoText: "", // Clear input
                searchText: state.searchText,
                filter: state.filter,
                isLoading: state.isLoading,
                error: nil
            )
            
        case .toggleTodo(let id):
            let updatedTodos = state.todos.map { todo in
                if todo.id == id {
                    var updatedTodo = todo
                    updatedTodo.isCompleted.toggle()
                    return updatedTodo
                }
                return todo
            }
            
            return TodoState(
                todos: updatedTodos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .deleteTodo(let id):
            let filteredTodos = state.filteredTodos.filter { $0.id != id }
            return TodoState(
                todos: filteredTodos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .updateSearchText(let text):
            return TodoState(
                todos: state.todos,
                newTodoText: state.newTodoText,
                searchText: text,
                filter: state.filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .setFilter(let filter):
            return TodoState(
                todos: state.todos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .clearCompleted:
            let pendingTodos = state.todos.filter { !$0.isCompleted }
            return TodoState(
                todos: pendingTodos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: state.isLoading,
                error: state.error
            )
            
        case .loadTodos:
            return TodoState(
                todos: state.todos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: true,
                error: nil
            )
            
        case .todosLoaded(let todos):
            return TodoState(
                todos: todos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: false,
                error: nil
            )
            
        case .errorOccurred(let error):
            return TodoState(
                todos: state.todos,
                newTodoText: state.newTodoText,
                searchText: state.searchText,
                filter: state.filter,
                isLoading: false,
                error: error
            )
        }
    }
}
