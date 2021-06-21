//
//  File.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Todo

public struct TodosView: View {
    
    let store: Store<Todos, TodosAction>
    @ObservedObject var viewStore: ViewStore<ViewState, TodosAction>
    
    public init(store: Store<Todos, TodosAction>) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }
    
    struct ViewState: Equatable {
        let editMode: EditMode
        let filter: Todos.Filter
        let isClearCompletedButtonDisabled: Bool
        
        init(state: Todos) {
            self.editMode = state.editMode
            self.filter = state.filter
            self.isClearCompletedButtonDisabled = !state.todos.contains(where: \.isComplete)
        }
    }
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Picker(
                    "Filter",
                    selection: self.viewStore.binding(get: \.filter, send: TodosAction.filterPicked).animation()
                ) {
                    ForEach(Todos.Filter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    ForEachStore(
                        self.store.scope(state: \.filteredTodos, action: TodosAction.todo(id:action:)),
                        content: TodoView.init(store:)
                    )
                    .onDelete { self.viewStore.send(.delete($0)) }
                    .onMove { self.viewStore.send(.move($0, $1)) }
                }
            }
            .navigationBarTitle("Todos")
            .navigationBarItems(
                trailing: HStack(spacing: 20) {
                    EditButton()
                    Button("Clear Completed") {
                        self.viewStore.send(.clearCompletedButtonTapped, animation: .default)
                    }
                    .disabled(self.viewStore.isClearCompletedButtonDisabled)
                    Button("Add Todo") { self.viewStore.send(.addTodoButtonTapped, animation: .default) }
                }
            )
            .environment(
                \.editMode,
                self.viewStore.binding(get: \.editMode, send: TodosAction.editModeChanged)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
