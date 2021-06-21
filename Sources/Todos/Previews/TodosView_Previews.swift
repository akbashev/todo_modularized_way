//
//  File.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import SharedModels

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView(
            store: Store(
                initialState: Todos(todos: .mock),
                reducer: todosReducer,
                environment: TodosEnvironment(
                    mainQueue: .main,
                    uuid: UUID.init
                )
            )
        )
    }
}

extension IdentifiedArray where ID == UUID, Element == Todo {
    static let mock: Self = [
        Todo(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEDDEADBEEF")!,
            description: "Check Mail",
            isComplete: false
        ),
        Todo(
            id: UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")!,
            description: "Buy Milk",
            isComplete: false
        ),
        Todo(
            id: UUID(uuidString: "D00DCAFE-D00D-CAFE-D00D-CAFED00DCAFE")!,
            description: "Call Mom",
            isComplete: true
        ),
    ]
}
