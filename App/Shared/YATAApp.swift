//
//  YATAApp.swift
//  Shared
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import SwiftUI
import Todos
import ComposableArchitecture

@main
struct YATAApp: App {
    let store = Store(
        initialState: Todos(),
        reducer: todosReducer,
        environment: TodosEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            uuid: UUID.init
        )
    )
    
    var body: some Scene {
        WindowGroup {
            TodosView(store: store)
        }
    }
}
