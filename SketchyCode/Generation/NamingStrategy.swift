//
//  NamingStrategy.swift
//  SketchyCode
//
//  Created by Brian King on 10/5/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// A naming strategy is resposible for creating names for declarations.
protocol NamingStrategy {
    func name(for variable: VariableRef) -> String
}

// A bad naming strategy.
class CounterNamingStrategy: NamingStrategy {
    var counter: Int = 0
    var names: [UUID: String] = [:]

    func name(for uuid: UUID, type: String) -> String {
        if let name = names[uuid] {
            return name
        }
        let name = type.appending(String(describing: counter))
        counter += 1
        names[uuid] = name
        return name
    }

    func name(for variable: VariableRef) -> String {
        return name(for: variable.uuid, type: variable.type.simpleName)
    }
}
