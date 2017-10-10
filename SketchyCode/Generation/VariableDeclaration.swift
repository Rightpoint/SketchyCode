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
    var initialization: ClosureDeclaration
    init(type: TypeRef, initializers: [Generator]) {
        self.value = VariableRef(uuid: UUID(), type: type)
        self.initialization = ClosureDeclaration(generators: initializers)
    }

    func generate(in context: Scope, writer: Writer) throws {
        let name = try context.name(for: value, isLeadingVariable: false)
        writer.append(line: "let \(name): \(value.type.name)", addNewline: false)

        if initialization.hasContent {
            try initialization.generate(in: try context.nonTypeContext(), writer: writer)
        } else {
            writer.append(line: "")
        }
    }
}

extension Scope {

    func makeVariable(ofType type: TypeRef) -> VariableDeclaration {
        let variable = VariableDeclaration(type: type, initializers: [])
        add(variable)
        return variable
    }
}

