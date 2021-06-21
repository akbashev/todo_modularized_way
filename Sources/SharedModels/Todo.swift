//
//  Todo.swift
//  
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import Foundation

public struct Todo: Codable, Equatable {

    public let id: UUID
    public var description = ""
    public var isComplete = false
    
    public init(
        id: UUID = UUID(),
        description: String = "",
        isComplete: Bool = false
    ) {
        self.id = id
        self.description = description
        self.isComplete = isComplete
    }
    
}
