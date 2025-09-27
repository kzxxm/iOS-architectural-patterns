//
//  Presenter.swift
//  MVP Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import Combine
import SwiftUI

// MARK: - Presenter
class TodoPresenter: ObservableObject {
    private var model: TodoModel
    @Published var displayedTodos: [TodoDisplayItem] = []
    @Published var isAddButtonEnabled: Bool = false
    @Published var navigationTitle: String = "My Todos"
    
    init(model: TodoModel) {
        self.model = model
        setupBindings()
        updateView()
    }
    
    private func setupBindings() {
        model.$todos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateView()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Presentation Logic
    private func updateView() {
        displayedTodos = model.todos.enumerated().map { index, todo in
            TodoDisplayItem(
                id: todo.id,
                title: todo.title,
                isCompleted: todo.isCompleted,
                displayText: todo.title,
                textColor: todo.isCompleted ? .gray : .primary,
                strikethrough: todo.isCompleted,
                buttonText: todo.isCompleted ? "Undo" : "Complete"
            )
        }
        
        navigationTitle = "My Todos (\(model.todos.count))"
    }
    
    
    // MARK: - User Actions
    func didTapAddButton(with title: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newTodo = TodoItem(title: title.trimmingCharacters(in: .whitespacesAndNewlines))
        model.addTodo(newTodo)
    }
    
    func didTapToggleButton(for todoId: UUID) {
        guard let index = model.todos.firstIndex(where: { $0.id == todoId }) else { return }
        
        var updatedTodo = model.todos[index]
        updatedTodo.isCompleted.toggle()
        model.updateTodo(at: index, with: updatedTodo)
    }
    
    func didRequestDelete(for todoId: UUID) {
        guard let index = model.todos.firstIndex(where: { $0.id == todoId }) else { return }
        model.deleteTodo(at: index)
    }
    
    func didChangeTextInput(_ text: String) {
        isAddButtonEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    // MARK: - View State Queries
    func getCompletedCount() -> Int {
        return model.todos.filter { $0.isCompleted }.count
    }
    
    func getPendingCount() -> Int {
        return model.todos.filter { !$0.isCompleted }.count
    }
}

// MARK: - For better testing, you could also create a protocol
protocol TodoPresenterProtocol: ObservableObject {
    var displayedTodos: [TodoDisplayItem] { get }
    var isAddButtonEnabled: Bool { get }
    var navigationTitle: String { get }
    
    func didTapAddButton(with title: String)
    func didTapToggleButton(for todoId: UUID)
    func didRequestDelete(for todoId: UUID)
    func didChangeTextInput(_ text: String)
}
