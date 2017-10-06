//
//  NamingStrategy.swift
//  SketchyCode
//
//  Created by Brian King on 10/5/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

let namingStrategy: NamingStrategy = CounterNamingStrategy()

protocol NamingStrategy {
    func name(for declaration: Declaration) -> String
}

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

    func name(for declaration: Declaration) -> String {
        switch declaration {
        case .variable(let object):
            return name(for: object.uuid, type: object.type.simpleName)
        case .type(let objectType):
            return objectType.name
        }
    }
}
