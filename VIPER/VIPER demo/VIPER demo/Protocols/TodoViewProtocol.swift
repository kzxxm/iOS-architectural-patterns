//
//  TodoViewProtocol.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import Foundation
import Combine

// MARK: - View Protocol
protocol TodoViewProtocol: AnyObject {
    var presenter: TodoPresenterProtocol? { get set }
    
    func showTodos(_ todos: [TodoEntity])
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
    func clearNewTodoText()
    func updateStats(pending: Int, completed: Int)
}

// MARK: - Presenter Protocol
protocol TodoPresenterProtocol: AnyObject {
    var view: TodoViewProtocol? { get set }
    var interactor: TodoInteractorProtocol? { get set }
    var router: TodoRouterProtocol? { get set }
    
    func viewDidLoad()
    func addTodo(title: String)
    func toggleTodo(id: UUID)
    func deleteTodo(id: UUID)
    func updateSearchText(_ text: String)
    func updateFilter(_ filter: TodoFilter)
    func clearCompleted()
    func showTodoDetail(for todo: TodoEntity)
}

// MARK: - Interactor Protocol
protocol TodoInteractorProtocol: AnyObject {
    var presenter: TodoInteractorOutputProtocol? { get set }
    var dataManager: TodoDataManagerProtocol? { get set }
    
    func loadTodos()
    func addTodo(title: String)
    func updateTodo(_ todo: TodoEntity)
    func deleteTodo(id: UUID)
    func clearCompletedTodos()
}

// MARK: - Interactor Output Protocol
protocol TodoInteractorOutputProtocol: AnyObject {
    func todosDidLoad(_ todos: [TodoEntity])
    func todoDidAdd(_ todo: TodoEntity)
    func todoDidUpdate(_ todo: TodoEntity)
    func todoDidDelete(id: UUID)
    func didFailWithError(_ error: Error)
}

// MARK: - Router Protocol
protocol TodoRouterProtocol: AnyObject {
    func presentTodoDetail(for todo: TodoEntity, from view: TodoViewProtocol)
    func dismissTodoDetail()
}

// MARK: - Data Manager Protocol
protocol TodoDataManagerProtocol: AnyObject {
    func loadTodos() async throws -> [TodoEntity]
    func saveTodos(_ todos: [TodoEntity]) async throws
    func deleteTodo(id: UUID) async throws
}
