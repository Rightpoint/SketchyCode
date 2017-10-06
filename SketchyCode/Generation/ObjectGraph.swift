//
//  ObjectGraph.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct ObjectType {
    let name: String

    var simpleName: String {
        // prune namespace and camel case
        return name
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


struct Object {
    let uuid = UUID()
    let type: ObjectType
}

extension Object {
    init(ofType name: String) {
        self.init(type: ObjectType(name: name))
    }

    func generate(in context: DeclarationContext, isFirstToken: Bool) throws -> String {
        let declaration = try context.declaration(for: self)
        let name = namingStrategy.name(for: declaration)
        if isFirstToken {
            if context.containingRepresentation == declaration {
                return ""
            } else {
                return name.appending(".")
            }
        } else {
            return name
        }
    }
}

extension Object: Equatable {
    static func ==(lhs: Object, rhs: Object) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.type == rhs.type
    }
}

