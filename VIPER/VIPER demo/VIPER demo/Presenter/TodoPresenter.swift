//
//  TodoPresenter.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//
import Foundation

class TodoPresenter: TodoPresenterProtocol, TodoInteractorOutputProtocol {
    weak var view: TodoViewProtocol?
    var interactor: TodoInteractorProtocol?
    var router: TodoRouterProtocol?
    
    private var allTodos: [TodoEntity] = []
    private var searchText = ""
    private var currentFilter: TodoFilter = .all
    
    // MARK: - Presenter Protocol
    func viewDidLoad() {
        view?.showLoading(true)
        interactor?.loadTodos()
    }
    
    func addTodo(title: String) {
        print("Presenter: Adding todo with title: \(title)")
        interactor?.addTodo(title: title)
    }
    
    func toggleTodo(id: UUID) {
        print("Presenter: Toggling todo with id: \(id)")
        guard let todoIndex = allTodos.firstIndex(where: { $0.id == id }) else {
            print("Presenter: Todo not found with id: \(id)")
            return
        }
        
        var todo = allTodos[todoIndex]
        let oldStatus = todo.isCompleted
        todo.isCompleted.toggle()
        print("Presenter: Toggling todo '\(todo.title)' from \(oldStatus) to \(todo.isCompleted)")
        
        // Update local array immediately for responsive UI
        allTodos[todoIndex] = todo
        
        // Update the view immediately
        updateFilteredTodos()
        updateStats()
        
        // Save changes
        interactor?.updateTodo(todo)
    }
    
    func deleteTodo(id: UUID) {
        interactor?.deleteTodo(id: id)
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        updateFilteredTodos()
    }
    
    func updateFilter(_ filter: TodoFilter) {
        currentFilter = filter
        updateFilteredTodos()
    }
    
    func clearCompleted() {
        interactor?.clearCompletedTodos()
    }
    
    func showTodoDetail(for todo: TodoEntity) {
        guard let view = view else { return }
        router?.presentTodoDetail(for: todo, from: view)
    }
    
    // MARK: - Interactor Output Protocol
    func todosDidLoad(_ todos: [TodoEntity]) {
        print("Presenter: Received \(todos.count) todos")
        allTodos = todos
        view?.showLoading(false)
        updateFilteredTodos()
        updateStats()
    }
    
    func todoDidAdd(_ todo: TodoEntity) {
        print("Presenter: Todo added: \(todo.title)")
        allTodos.append(todo)
        view?.clearNewTodoText()
        updateFilteredTodos()
        updateStats()
    }
    
    func todoDidUpdate(_ todo: TodoEntity) {
        print("Presenter: Todo updated: \(todo.title), isCompleted: \(todo.isCompleted)")
        if let index = allTodos.firstIndex(where: { $0.id == todo.id }) {
            allTodos[index] = todo
            updateFilteredTodos()
            updateStats()
        }
    }
    
    func todoDidDelete(id: UUID) {
        allTodos.removeAll { $0.id == id }
        updateFilteredTodos()
        updateStats()
    }
    
    func didFailWithError(_ error: Error) {
        print("Presenter: Error occurred: \(error.localizedDescription)")
        view?.showLoading(false)
        view?.showError(error.localizedDescription)
    }
    
    // MARK: - Private Methods
    private func updateFilteredTodos() {
        var filtered = allTodos
        
        // Apply filter
        switch currentFilter {
        case .all:
            break
        case .pending:
            filtered = filtered.filter { !$0.isCompleted }
        case .completed:
            filtered = filtered.filter { $0.isCompleted }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort by creation date
        filtered.sort { $0.createdAt > $1.createdAt }
        
        print("Presenter: Showing \(filtered.count) filtered todos")
        view?.showTodos(filtered)
    }
    
    private func updateStats() {
        let pending = allTodos.filter { !$0.isCompleted }.count
        let completed = allTodos.filter { $0.isCompleted }.count
        print("Presenter: Stats - Pending: \(pending), Completed: \(completed)")
        view?.updateStats(pending: pending, completed: completed)
    }
}
