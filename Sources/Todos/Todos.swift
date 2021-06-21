//
//  File.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import SharedModels
import Todo

public struct Todos: Equatable {
    
    public enum Filter: LocalizedStringKey, CaseIterable, Hashable {
        case all = "All"
//        case active = "Active"
        case completed = "Completed"
    }

    public var todos: IdentifiedArrayOf<Todo> = []

    public var editMode: EditMode = .inactive
    public var filter: Filter = .all
    
    public init(editMode: EditMode = .inactive, filter: Filter = .all, todos: IdentifiedArrayOf<Todo> = []) {
        self.editMode = editMode
        self.filter = filter
        self.todos = todos
    }
    
    var filteredTodos: IdentifiedArrayOf<Todo> {
        switch filter {
//        case .active: return self.todos.filter { !$0.isComplete }
        case .all: return self.todos
        case .completed: return self.todos.filter(\.isComplete)
        }
    }
}

public enum TodosAction: Equatable {
    case addTodoButtonTapped
    case clearCompletedButtonTapped
    case delete(IndexSet)
    case editModeChanged(EditMode)
    case filterPicked(Todos.Filter)
    case move(IndexSet, Int)
    case sortCompletedTodos
    case todo(id: UUID, action: TodoAction)
}

public struct TodosEnvironment {

    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
    
    public init(mainQueue: AnySchedulerOf<DispatchQueue>, uuid: @escaping () -> UUID) {
        self.mainQueue = mainQueue
        self.uuid = uuid
    }
    
}

public let todosReducer = Reducer<Todos, TodosAction, TodosEnvironment>.combine(
    todoReducer.forEach(
        state: \.todos,
        action: /TodosAction.todo(id:action:),
        environment: { _ in TodoEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .addTodoButtonTapped:
            state.todos.insert(Todo(id: environment.uuid()), at: 0)
            return .none
            
        case .clearCompletedButtonTapped:
            state.todos.removeAll(where: \.isComplete)
            return .none
            
        case let .delete(indexSet):
            state.todos.remove(atOffsets: indexSet)
            return .none
            
        case let .editModeChanged(editMode):
            state.editMode = editMode
            return .none
            
        case let .filterPicked(filter):
            state.filter = filter
            return .none
            
        case let .move(source, destination):
            state.todos.move(fromOffsets: source, toOffset: destination)
            return Effect(value: .sortCompletedTodos)
                .delay(for: .milliseconds(100), scheduler: environment.mainQueue)
                .eraseToEffect()
            
        case .sortCompletedTodos:
            state.todos.sortCompleted()
            return .none
            
        case .todo(id: _, action: .checkBoxToggled):
            struct TodoCompletionId: Hashable {}
            return Effect(value: .sortCompletedTodos)
                .debounce(id: TodoCompletionId(), for: 1, scheduler: environment.mainQueue.animation())
            
        case .todo:
            return .none
        }
    }
).debugActions(actionFormat: .labelsOnly)

extension IdentifiedArray where ID == UUID, Element == Todo {
    fileprivate mutating func sortCompleted() {
        // Simulate stable sort
        self = IdentifiedArray(
            self.enumerated()
                .sorted(by: { lhs, rhs in
                    (rhs.element.isComplete && !lhs.element.isComplete) || lhs.offset < rhs.offset
                })
                .map(\.element)
        )
    }
}

