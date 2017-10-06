//
//  ObjectGraph.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// ObjectType specifies the type name to use
struct ObjectType {
    var name: String

    var simpleName: String {
        return name.objcnessRemoved().variabled
    }
    var isOptional: Bool {
        return name.hasSuffix("?")
    }
}

extension ObjectType: Equatable {
    static func ==(lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs.name == rhs.name
    }
}

// Reference to a variable managed by code generation. Variables do not have names
// just a uniqueness identifier and a type.
struct VariableRef {
    let uuid = UUID()
    var type: ObjectType
}

extension VariableRef {
    init(ofType name: String) {
        self.init(type: ObjectType(name: name))
    }
}

extension VariableRef: Equatable {
    static func ==(lhs: VariableRef, rhs: VariableRef) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.type == rhs.type
    }
}

