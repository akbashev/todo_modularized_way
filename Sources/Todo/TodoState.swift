//
//  TodoState.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation
import ComposableArchitecture
import SharedModels

public enum TodoAction: Equatable {
  case checkBoxToggled
  case textFieldChanged(String)
}

public struct TodoEnvironment {
    public init() {}
}

public let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { todo, action, _ in
  switch action {
  case .checkBoxToggled:
    todo.isComplete.toggle()
    return .none

  case let .textFieldChanged(description):
    todo.description = description
    return .none
  }
}

extension Todo: Identifiable {}
