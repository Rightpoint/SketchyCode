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
    var counter: [String: Int] = [:]
    var names: [UUID: String] = [:]

    func name(for variable: VariableRef) -> String {
        if variable.isSelf {
            return "self"
        }
        if let name = names[variable.uuid] {
            return name
        }
        if let hint = variable.userVariableName {
            self.names[variable.uuid] = hint
            return hint
        }
        let typeName = variable.type.name
        var name = typeName
        if name.hasPrefix("UI") {
            name.removeFirst()
            name.removeFirst()
        }
        if let first = name.indices.first {
            name.replaceSubrange(first...first, with: String(name[first]).lowercased())
        }
        var counter = self.counter[typeName] ?? 0
        if counter != 0 {
            name.append(String(describing: counter))
        }
        counter += 1
        self.counter[typeName] = counter
        self.names[variable.uuid] = name
        return name
    }
}
