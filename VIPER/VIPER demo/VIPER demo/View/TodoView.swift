//
//  ContentView.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject private var viewModel: TodoViewObservable
    
    init(viewModel: TodoViewObservable) {
        self.viewModel = viewModel
    }
    
    // For preview purposes - this should not be used in production
    init() {
        self.viewModel = TodoViewObservable()
        setupVIPER()
    }
    
    private func setupVIPER() {
        let presenter = TodoPresenter()
        let interactor = TodoInteractor()
        let router = TodoRouter()
        let dataManager = TodoDataManager()
        
        // Wire up dependencies
        viewModel.presenter = presenter
        presenter.view = viewModel
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.dataManager = dataManager
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Add Todo Section
                HStack {
                    TextField("Enter new todo...", text: $viewModel.newTodoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            addNewTodo()
                        }
                    
                    Button("Add") {
                        addNewTodo()
                    }
                    .disabled(viewModel.newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                
                // Search Section
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search todos...", text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { text in
                            viewModel.presenter?.updateSearchText(text)
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button("Clear") {
                            viewModel.searchText = ""
                            viewModel.presenter?.updateSearchText("")
                        }
                        .font(.caption)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Filter Section
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(TodoFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 8)
                .onChange(of: viewModel.selectedFilter) { filter in
                    viewModel.presenter?.updateFilter(filter)
                }
                
                // Stats Section
                HStack {
                    Text("\(viewModel.pendingCount) pending")
                    Spacer()
                    Text("\(viewModel.completedCount) completed")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Todo List
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                        Text("Loading todos...")
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.todos, id: \.id) { todo in
                            TodoRowView(todo: todo) { action in
                                handleTodoAction(action, for: todo)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.presenter?.deleteTodo(id: viewModel.todos[index].id)
                            }
                        }
                    }
                    .id(viewModel.todos.count) // Force refresh when todos change
                }
            }
            .navigationTitle("Todos (\(viewModel.pendingCount + viewModel.completedCount))")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Options") {
                        Button("Clear Completed") {
                            viewModel.presenter?.clearCompleted()
                        }
                        .disabled(viewModel.completedCount == 0)
                    }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .onAppear {
            viewModel.presenter?.viewDidLoad()
        }
    }
    
    private func addNewTodo() {
        let title = viewModel.newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        viewModel.presenter?.addTodo(title: title)
    }
    
    private func handleTodoAction(_ action: TodoRowAction, for todo: TodoEntity) {
        print("TodoView: Handling action \(action) for todo: \(todo.title)")
        switch action {
        case .toggle:
            print("TodoView: Calling toggleTodo for id: \(todo.id)")
            viewModel.presenter?.toggleTodo(id: todo.id)
        case .showDetail:
            viewModel.presenter?.showTodoDetail(for: todo)
        }
    }
}

// MARK: - Preview
struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoModule.build()
    }
}
