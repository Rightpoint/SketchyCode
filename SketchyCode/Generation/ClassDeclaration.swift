//
//  ClassDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class ClassDeclaration: Scope {
    let inheriting: String?

    // This selfRef was a shortcut to simplify self transformations. It should be
    // removed and modeled more explicitly once expression transformations are
    // more evolved.
    let selfRef: VariableRef
    init(selfRef: VariableRef, inheriting: String? = nil) {
        self.inheriting = inheriting
        self.selfRef = selfRef
        super.init()
    }

    override func generate(in context: Scope, writer: Writer) throws {
        if let inheriting = inheriting {
            writer.append(line: "class \(selfRef.type.name): \(inheriting) ", addNewline: false)
        } else {
            writer.append(line: "class \(selfRef.type.name) ", addNewline: false)
        }
        try writer.block() {
            try super.generate(in: self, writer: writer)
        }
    }

    override func path(for variable: VariableRef, preceeding: [VariableRef] = []) -> [VariableRef] {
        if selfRef == variable {
            return preceeding + [selfRef]
        }
        return super.path(for: variable, preceeding: preceeding)
    }
}

extension Scope {

    func makeClass(ofType type: TypeRef, for variable: VariableDeclaration) -> ClassDeclaration {
        let newDefinition = VariableRef(uuid: variable.value.uuid, type: type)
        let cls = ClassDeclaration(
            selfRef: newDefinition,
            inheriting: variable.value.type.name)
        variable.value = newDefinition
        add(cls)
        return cls
    }
}
