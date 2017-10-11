//
//  ObjectGraph.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// TypeRef specifies the type name to use
struct TypeRef {
    let name: String

    var simpleName: String {
        return name.objcnessRemoved().variabled
    }
    var isOptional: Bool {
        return name.hasSuffix("?")
    }
}

extension TypeRef: ExpressibleByStringLiteral {

    init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }

    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(name: value)
    }
}

extension TypeRef: Equatable {
    static func ==(lhs: TypeRef, rhs: TypeRef) -> Bool {
        return lhs.name == rhs.name
    }
}

// Reference to a variable managed by code generation. Variables do not have names
// just a uniqueness identifier and a type.
struct VariableRef {
    let uuid: UUID
    let type: TypeRef
}

extension VariableRef {
    init(ofType name: String) {
        self.init(uuid: UUID(), type: TypeRef(name: name))
    }
}

extension VariableRef: Equatable {
    static func ==(lhs: VariableRef, rhs: VariableRef) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.type == rhs.type
    }
}

