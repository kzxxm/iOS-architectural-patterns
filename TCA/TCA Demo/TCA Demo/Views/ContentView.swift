//
//  ContentView.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<TodoReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0) {
                    // Add Todo Section
                    HStack {
                        TextField(
                            "Enter new todo...",
                            text: viewStore.binding(
                                get: \.newTodoText,
                                send: TodoReducer.Action.newtodoTextChanged
                            )
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            viewStore.send(.addTodoButtonTapped)
                        }
                        
                        Button("Add") {
                            viewStore.send(.addTodoButtonTapped)
                        }
                        .disabled(!viewStore.canAddTodo)
                    }
                    .padding()
                    
                    // Search Section
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField(
                            "Search todos...",
                            text: viewStore.binding(
                                get: \.searchText,
                                send: TodoReducer.Action.searchTextChanged
                            )
                        )
                        
                        if !viewStore.searchText.isEmpty {
                            Button("Clear") {
                                viewStore.send(.searchTextChanged(""))
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
                    Picker("Filter", selection: viewStore.binding(
                        get: \.filter,
                        send: TodoReducer.Action.filterChanged
                    )) {
                        ForEach(TodoFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Stats Section
                    HStack {
                        Text("\(viewStore.pendingCount) pending")
                        Spacer()
                        Text("\(viewStore.completedCount) completed")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Todo List
                    List {
                        ForEach(viewStore.filteredTodos) { todo in
                            TodoRowView(todo: todo, store: store)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewStore.send(.todoDeleted(id: viewStore.filteredTodos[index].id))
                            }
                        }
                    }
                    
                    if viewStore.isLoading {
                        HStack {
                            ProgressView()
                            Text("Loading todos...")
                        }
                        .padding()
                    }
                }
                .navigationTitle("Todos (\(viewStore.todos.count))")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear Completed") {
                            viewStore.send(.clearCompletedButtonTapped)
                        }
                        .disabled(viewStore.completedCount == 0)
                    }
                }
                .alert(
                    item: viewStore.binding(
                        get: { $0.alert.map(AlertItem.init) },
                        send: { _ in .alertDismissed }
                    )
                ) { _ in
                    Alert(title: Text("Error"))
                }
            }
        }
        .onAppear {
            store.send(.loadTodos)
        }
    }
}

private struct AlertItem: Identifiable {
    let id = UUID()
    let alert: AlertState<TodoReducer.Action.Alert>
}

#Preview {
    ContentView(
        store: Store(initialState: TodoReducer.State(
            todos: IdentifiedArray(uniqueElements: [
                Todo(title: "Learn TCA", isCompleted: false),
                Todo(title: "Build apps", isCompleted: true)
            ])
        )) {
            TodoReducer()
        } withDependencies: {
            $0.todoClient = .mock
        }
    )
}
