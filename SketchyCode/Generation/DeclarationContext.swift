//
//  DeclarationContext.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class DeclarationContext: Generator {
    weak var parent: DeclarationContext?
    var children: [Generator] = []
    var declarations: [Declaration] = []
    let representing: Declaration?

    func generate(in context: DeclarationContext, writer: Writer) throws {
        try children.forEach { try $0.generate(in: self, writer: writer) }
    }

    init(representing: Declaration? = nil) {
        self.representing = representing
    }
}

extension DeclarationContext {
    func generate(writer: Writer) throws {
        try generate(in: self, writer: writer)
    }
}

extension DeclarationContext {
    func makeVariable(ofType typeName: String) -> VariableDeclaration {
        let variable = VariableDeclaration(type: ObjectType(name: typeName), initializers: [])
        add(variable)
        declarations.append(.variable(variable.value))
        return variable
    }

    func makeClass(ofType type: String, inheriting: String? = nil) -> ClassDeclaration {
        let cls = ClassDeclaration(
            representingSelf: Object(ofType: type),
            inheriting: inheriting)
        add(cls)
        return cls
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


    func nonTypeContext() throws -> DeclarationContext {
        if self as? ClassDeclaration == nil {
            return self
        } else {
            return try parentConext().nonTypeContext()
        }
    }

    func declaration(for object: Object) throws -> Declaration {
        struct MissingObjectDeclaration: Error {
            let object: Object
            let declarationContext: DeclarationContext
        }
        for declaration in declarations {
            if let declObject = declaration.object, declObject.uuid == object.uuid {
                return declaration
            }
        }
        if let parent = parent {
            return try parent.declaration(for: object)
        } else {
            throw MissingObjectDeclaration(object: object, declarationContext: self)
        }
    }

    // This is not a very accurate representation of logic for Swift, but it should
    // work for detecting implicit self.
    var containingRepresentation: Declaration? {
        if let representation = representing {
            return representation
        } else if let parent = parent {
            return parent.containingRepresentation
        } else {
            return nil
        }
    }

    func add(_ generator: Generator) {
        children.append(generator)
        if let declaration = generator as? DeclarationContext {
            declaration.parent = self
        }
    }
    func add(contentsOf generators: [Generator]) {
        for generator in generators {
            add(generator)
        }
    }

}

class GlobalDeclarationContext: DeclarationContext {
    override func generate(in context: DeclarationContext, writer: Writer) throws {
        writer.append(line: "// Automatically generated. Do Not Edit!")
        try super.generate(in: context, writer: writer)
    }
}

class ClassDeclaration: DeclarationContext {
    let inheriting: String?
    init(representingSelf: Object, inheriting: String? = nil) {
        self.inheriting = inheriting
        super.init(representing: .variable(representingSelf))
        declarations.append(.variable(representingSelf))
    }

    var representingSelf: Object {
        guard let representing = representing,
            case .variable(let representingSelf) = representing else {
                fatalError("Invalid state")
        }
        return representingSelf
    }

    override func generate(in context: DeclarationContext, writer: Writer) throws {
        if let inheriting = inheriting {
            writer.append(line: "class \(representingSelf.type.name): \(inheriting) ", addNewline: false)
        } else {
            writer.append(line: "class \(representingSelf.type.name) ", addNewline: false)
        }
        try writer.block() {
            try super.generate(in: self, writer: writer)
        }
    }

}

class VariableDeclaration: Generator {
    let value: Object
    var initialization: ClosureDeclaration
    init(type: ObjectType, initializers: [Generator]) {
        self.value = Object(type: type)
        self.initialization = ClosureDeclaration(generators: initializers)
    }

    func generate(in context: DeclarationContext, writer: Writer) throws {
        let name = try value.generate(in: context, isFirstToken: false)
        writer.append(line: "let \(name): \(value.type.name)", addNewline: false)

        if initialization.hasContent {
            try initialization.generate(in: try context.nonTypeContext(), writer: writer)
        } else {
            writer.append(line: "")
        }
    }
}

class ClosureDeclaration: DeclarationContext {

    init(generators: [Generator]) {
        super.init()
        children = generators
    }

    var hasContent: Bool {
        return children.count > 0
    }

    override func generate(in context: DeclarationContext, writer: Writer) throws {
        if children.count == 1 {
            try children[0].generate(in: self, writer: writer)
        } else {
            try writer.block(appending: "()") {
                try children.forEach { try $0.generate(in: self, writer: writer) }
            }
        }
    }
}

