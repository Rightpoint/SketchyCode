//
//  DeclarationContext.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class DeclarationContext {
    weak var parent: DeclarationContext?
    var children: [DeclarationContext] = []
    var references: [DeclarationReference] = []

    func generate(writer: Writer) throws {
        try children.forEach { try $0.generate(writer: writer) }
    }
}

extension DeclarationContext {
    func parentConext() throws -> DeclarationContext {
        struct MissingParentContext: Error {
            let declarationContext: DeclarationContext
        }

        guard let parent = parent else {
            throw MissingParentContext(declarationContext: self)
        }
        return parent
    }

    func addChild(_ declaration: DeclarationContext) {
        declaration.parent = self
        children.append(declaration)
    }

    func addReference(_ reference: DeclarationReference) {
        references.append(reference)
    }

    func reference(for object: Object) throws -> DeclarationReference {
        struct MissingVariableReference: Error {
            let object: Object
            let declarationContext: DeclarationContext
        }
        for reference in references {
            if reference.object.uuid == object.uuid {
                return reference
            }
        }
        if let parent = parent {
            return try parent.reference(for: object)
        } else {
            throw MissingVariableReference(object: object, declarationContext: self)
        }
    }

}

class GlobalDeclarationContext: DeclarationContext {
    override func generate(writer: Writer) throws {
        writer.append(line: "// Automatically generated. Do Not Edit!")
        try super.generate(writer: writer)
    }
}

struct GeneratorsDoNotProvide: Error {
    let declarationContext: DeclarationContext
}

struct GeneratorsProvidedMismatch: Error {
    let expected: Object
    let actual: Object
}

class VariableDeclaration: DeclarationContext {
    let object: Object
    var generators: [Generator] = []

    init(object: Object, generators: [Generator]) {
        self.object = object
        self.generators = generators
        super.init()
    }

    override func generate(writer: Writer) throws {
        let variableName = try reference(for: object).name
        let variableType = object.type.name
        let line = "let \(variableName): \(variableType)"
        if generators.count == 0 {
            // This must be an injected property
            writer.append(line: line)
        } else {
            guard let first = generators.first, let provides = first.provides else {
                throw GeneratorsDoNotProvide(declarationContext: self)
            }
            guard provides.uuid == object.uuid else {
                throw GeneratorsProvidedMismatch(expected: object, actual: provides)
            }
            if generators.count == 1 {
                writer.append(line: line.appending(" = "), addNewline: false)
                try first.generate(in: self, writer: writer)
            } else {
                writer.append(line: line.appending(" = {"))
                try writer.indent {
                    try generators.forEach { try $0.generate(in: self, writer: writer) }
                }
                writer.append(line: "}")
            }
        }
    }
}

class ClosureDeclaration: DeclarationContext {
    var generators: [Generator] = []

    init(generators: [Generator]) {
        self.generators = generators
        super.init()
    }

    override func generate(writer: Writer) throws {
        if generators.count == 1 {
            try generators[0].generate(in: self, writer: writer)
        } else {
            writer.append(line: "{")
            try writer.indent {
                try generators.forEach { try $0.generate(in: self, writer: writer) }
            }
            writer.append(line: "}()")
        }
    }
}

