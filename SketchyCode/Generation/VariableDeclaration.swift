//
//  VariableDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class VariableDeclaration: Generator {
    var value: VariableRef
    var initialization: AssignmentExpression?
    init(type: TypeRef, initialization: AssignmentExpression? = nil) {
        self.value = VariableRef(uuid: UUID(), type: type)
        self.initialization = initialization
    }

    func generate(in scope: Scope, writer: Writer) throws {
        if let classDeclaration = scope as? ClassDeclaration, classDeclaration.selfDeclaration.value == self.value {
            return
        }
        let name = try scope.name(for: value, isLeadingVariable: false)

        if let initialization = initialization {
            writer.append(line: "let \(name): \(value.type.name) = ", addNewline: false)
            try initialization.generate(in: try scope.nonTypeScope(), writer: writer)
        } else {
            writer.append(line: "let \(name): \(value.type.name)")
        }
    }
}

extension Scope {

    func makeVariable(ofType type: TypeRef) -> VariableDeclaration {
        let variable = VariableDeclaration(type: type)
        add(variable)
        return variable
    }
}

