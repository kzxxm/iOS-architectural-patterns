//
//  ContentView.swift
//  MVVM Demo
//
//  Created by Kassim Mirza on 27/09/2025.
//

import SwiftUI

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                addTodoSection
                
                searchAndFilterSection
                
                statsSection
                
                todoList
            }
        }
    }
    
    private var addTodoSection: some View {
        HStack {
            TextField("Enter new todo...", text: $viewModel.newTodoText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    viewModel.addTodo()
                }
            
            Button("Add") {
                viewModel.addTodo()
            }
            .disabled(!viewModel.canAddTodo)
        }
        .padding()
    }
    
    private var searchAndFilterSection: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search todos...", text: $viewModel.searchText)
                
                if !viewModel.searchText.isEmpty {
                    Button("Clear") {
                        viewModel.clearSearch()
                    }
                    .font(.caption)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Button(viewModel.filterButtonText) {
                viewModel.toggleFilter()
            }
            .font(.caption)
        }
        .padding(.horizontal)
    }
    
    private var statsSection: some View {
        Text(viewModel.statsText)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.vertical, 8)
    }
    
    private var todoList: some View {
        List {
            ForEach(viewModel.filteredTodos) { todo in
                TodoRowView(todo: todo, viewModel: viewModel)
            }
            .onDelete(perform: viewModel.deleteTodos)
        }
    }
}

// MARK: - Todo Row Component
struct TodoRowView: View {
    let todo: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                
                Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(todo.isCompleted ? "Undo" : "Complete") {
                viewModel.toggleTodo(todo)
            }
            .font(.caption)
            .foregroundStyle(todo.isCompleted ? .orange : .green)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleTodo(todo)
        }
    }
}

#Preview {
    ContentView()
}
