//
//  TodoView.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import SharedModels

public struct TodoView: View {
    
    let store: Store<Todo, TodoAction>
    
    public init(
        store: Store<Todo, TodoAction>
    ) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkBoxToggled) }) {
                    Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(PlainButtonStyle())
                
                TextField(
                    "Untitled Todo",
                    text: viewStore.binding(get: \.description, send: TodoAction.textFieldChanged)
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
        }
    }
}
