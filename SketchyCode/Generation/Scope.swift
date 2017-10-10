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
                    let classPath = classDeclaration.path(for: variable, preceeding: preceeding + [variableDeclaration.value])
                    if classPath.count > 0 {
                        return classPath
                    }
                }
            }
        }
        return []
    }
}


extension Scope {

    func generate(writer: Writer) throws {
        try generate(in: self, writer: writer)
    }

    func name(for variable: VariableRef, isLeadingVariable: Bool) throws -> String {
        var path: [VariableRef] = self.path(for: variable)
        var nextScope = self.parent
        while path.count == 0 {
            if let scope = nextScope {
                path = scope.path(for: variable)
                nextScope = scope.parent
            } else {
                struct UnregisteredVariableRefError: Error {
                    let variable: VariableRef
                }
                throw UnregisteredVariableRefError(variable: variable)
            }
        }
        assert(path.last == variable)
        let classDeclaration: ClassDeclaration? = lookupContainer(where: { _ in true })
        let isSelfRef: Bool = classDeclaration?.selfRef == variable
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
    // This method has a horrible name, but I can't quite encapsulate the semantics.
    // This may be a naming issue, or I may have the exact semantics wrong.
    func lookupScope<T: Scope>(check: (T) -> Bool) -> T? {
        let childrenOfT = children.flatMap({ $0 as? T })
        if let result = childrenOfT.first(where: check) {
            return result
        }
        if let parent = parent {
            return parent.lookupScope(check: check)
        }
        return nil
    }

    func lookupContainer<T: Scope>(where check: (T) -> Bool) -> T? {
        if let selfOfT = self as? T, check(selfOfT) {
            return selfOfT
        } else if let parent = parent {
            return parent.lookupContainer(where: check)
        } else {
            return nil
        }
    }

    func lookup(typeName: String) -> ClassDeclaration? {
        return lookupScope(check: { $0.selfRef.type.name == typeName})
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
