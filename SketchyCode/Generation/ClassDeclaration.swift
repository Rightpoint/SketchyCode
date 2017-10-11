//
//  ClassDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class ClassDeclaration: Scope {
    let selfDeclaration: VariableDeclaration
    let inheriting: TypeRef?

    init(typeRef: TypeRef, inheriting: TypeRef? = nil) {
        self.selfDeclaration = VariableDeclaration(type: typeRef)
        self.inheriting = inheriting
        super.init()
        add(selfDeclaration)
    }

    override func generate(in context: Scope, writer: Writer) throws {
        if let inheriting = inheriting {
            writer.append(line: "class \(typeRef.name): \(inheriting.name) ", addNewline: false)
        } else {
            writer.append(line: "class \(typeRef.name) ", addNewline: false)
        }
        try writer.block() {
            try super.generate(in: self, writer: writer)
        }
    }
}

extension ClassDeclaration {

    func isSelf(ref: VariableRef) -> Bool {
        return selfDeclaration.value == ref
    }

    func contains(variable: VariableRef) -> Bool {
        return path(for: variable).count > 0
    }

    func contains(anyOf variables: [VariableRef]) -> Bool {
        for variable in variables {
            if contains(variable: variable) {
                return true
            }
        }
        return false
    }

    var typeRef: TypeRef {
        return selfDeclaration.value.type
    }
}


extension Scope {

    func makeClass(ofType type: TypeRef, for variable: VariableDeclaration) -> ClassDeclaration {
        let cls = ClassDeclaration(
            typeRef: type,
            inheriting: variable.value.type)
        add(cls)
        variable.value = VariableRef(uuid: variable.value.uuid, type: type)
        return cls
    }

    func moveExpressions(for variable: VariableDeclaration, to cls: ClassDeclaration) {
        var movedExpressions: [Expression] = []
        for (index, child) in children.enumerated().reversed() {
            guard let expression = child as? Expression else { continue }
            if cls.contains(anyOf: expression.dependent) ||
                expression.dependent.contains(variable.value) {
                children.remove(at: index)
                let transferred = expression.transform(
                    variable: variable.value,
                    to: cls.selfDeclaration.value)
                movedExpressions.insert(transferred, at: 0)
            }
        }
        cls.add(contentsOf: movedExpressions)
    }
}
