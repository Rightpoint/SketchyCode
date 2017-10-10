//
//  Scope.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// Scope defines a scope for declarations to live.
class Scope: Generator {
    weak var parent: Scope?
    var children: [Generator] = []

    func generate(in context: Scope, writer: Writer) throws {
        try children.forEach { try $0.generate(in: self, writer: writer) }
    }

    // Given a variable reference, look for a path to that variable from the
    // specified context.
    func path(for variable: VariableRef, preceeding: [VariableRef] = []) -> [VariableRef] {
        // This looks like a good candidate for a walker pattern. It also looks
        // like it will be slow.
        for child in children {
            if let variableDeclaration = child as? VariableDeclaration {
                if variable == variableDeclaration.value {
                    return preceeding + [variable]
                } else if let classDeclaration = lookup(typeName: variableDeclaration.value.type.name) {
                    return classDeclaration.path(for: variable, preceeding: preceeding + [variableDeclaration.value])
                }
            }
        }
        return preceeding
    }

    func name(for variable: VariableRef, isLeadingVariable: Bool) throws -> String {
        struct UnregisteredVariableRefError: Error {
            let variable: VariableRef
        }
        let path = self.path(for: variable)
        if path.count == 0 {
            throw UnregisteredVariableRefError(variable: variable)
        }
        let isSelfRef: Bool = containingClassDeclaration()?.selfRef == variable
        var variableNames: [String] = []
        for (index, variable) in path.enumerated() {
            let name = namingStrategy.name(for: variable)
            if isSelfRef {
                if isLeadingVariable && index == 0 {
                    continue
                } else {
                    variableNames.append("self")
                }
            } else {
                variableNames.append(name)
            }
        }
        var name = variableNames.joined(separator: ".")
        if isLeadingVariable && !isSelfRef {
            name.append(".")
        }
        return name
    }
}


extension Scope {
    func parentConext() throws -> Scope {
        struct MissingParentContext: Error {
            let declarationContext: Scope
        }

        guard let parent = parent else {
            throw MissingParentContext(declarationContext: self)
        }
        return parent
    }

    // Determine enclosing scope that is not a type. This is used to remove self
    // from scope when generating property assignment closures
    func nonTypeContext() throws -> Scope {
        if self as? ClassDeclaration == nil {
            return self
        } else {
            return try parentConext().nonTypeContext()
        }
    }

    func lookup(typeName: String) -> ClassDeclaration? {
        for child in children.flatMap({ $0 as? ClassDeclaration }) {
            if child.selfRef.type.name == typeName {
                return child
            }
        }
        if let parent = parent {
            return parent.lookup(typeName: typeName)
        }
        return nil
    }

    func add(_ generator: Generator) {
        children.append(generator)
        if let declaration = generator as? Scope {
            declaration.parent = self
        }
    }

    func add(contentsOf generators: [Generator]) {
        for generator in generators {
            add(generator)
        }
    }
}

extension Scope {
    func generate(writer: Writer) throws {
        try generate(in: self, writer: writer)
    }
}

extension Scope {
    func makeVariable(ofType type: TypeRef) -> VariableDeclaration {
        let variable = VariableDeclaration(type: type, initializers: [])
        add(variable)
        return variable
    }

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

// The global declaration context is low value top level declaration context.
class GlobalScope: Scope {
    override func generate(in context: Scope, writer: Writer) throws {
        writer.append(line: "// Automatically generated. Do Not Edit!")

        try children.forEach {
            if $0 is ClassDeclaration {
                try $0.generate(in: self, writer: writer)
            }
        }
        try children.forEach {
            if !($0 is ClassDeclaration) {
                try $0.generate(in: self, writer: writer)
            }
        }
    }
}

class ClassDeclaration: Scope {
    let inheriting: String?
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
    func containingClassDeclaration() -> ClassDeclaration? {
        if let classDecl = self as? ClassDeclaration {
            return classDecl
        } else if let parent = parent {
            return parent.containingClassDeclaration()
        } else {
            return nil
        }
    }
}

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

class ClosureDeclaration: Scope {

    init(generators: [Generator]) {
        super.init()
        children = generators
    }

    var hasContent: Bool {
        return children.count > 0
    }

    override func generate(in context: Scope, writer: Writer) throws {
        if children.count == 1 {
            try children[0].generate(in: self, writer: writer)
        } else {
            try writer.block(appending: "()") {
                try children.forEach { try $0.generate(in: self, writer: writer) }
            }
        }
    }
}
