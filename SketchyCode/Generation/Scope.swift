//
//  Scope.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// Scope defines a scope for declarations to live.
class Scope {
    weak var parent: Scope?
    var children: [Generator] = []
}

extension Scope {

    // Given a variable reference, look for a path to that variable from the
    // specified scope.
    func path(for variable: VariableRef, preceeding: [VariableRef] = []) -> [VariableRef] {
        for child in children {
            if let variableDeclaration = child as? VariableDeclaration {
                if variable == variableDeclaration.value {
                    return preceeding + [variable]
                } else if let classDeclaration = lookup(typeName: variableDeclaration.value.type.name) {
                    guard self !== classDeclaration else { continue }
                    let classPath = classDeclaration.path(for: variable, preceeding: preceeding + [variableDeclaration.value])
                    if classPath.count > 0 {
                        return classPath
                    }
                }
            }
        }
        return []
    }

    func parentConext() throws -> Scope {
        struct MissingParentScope: Error {
            let declarationScope: Scope
        }

        guard let parent = parent else {
            throw MissingParentScope(declarationScope: self)
        }
        return parent
    }

    // Determine enclosing scope that is not a type. This is used to remove self
    // from scope when generating property assignment closures
    func nonTypeScope() throws -> Scope {
        if self as? ClassDeclaration == nil {
            return self
        } else {
            return try parentConext().nonTypeScope()
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
        return lookupScope(check: { $0.typeRef.name == typeName})
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

    func add(expression parts: SyntaxPart...) {
        add(BasicExpression(parts: parts))
    }

    func remove(_ generator: AnyObject & Generator) throws {
        if let index = children
            .flatMap({ $0 as? AnyObject & Generator })
            .index(where: { $0 === generator}) {
            children.remove(at: index)
            if let scope = generator as? Scope {
                scope.parent = nil
            }
        } else {
            struct GeneratorNotInScopeError: Error {
                let generator: Generator
            }
            throw GeneratorNotInScopeError(generator: generator)
        }
    }
}

// A very boring scope.
final class GlobalScope: Scope {}
final class BlockExpression: Scope {
    var invoke: Bool = true
}

extension Scope {
    func makeBlock(children: [Generator]) -> BlockExpression {
        let block = BlockExpression()
        block.children = children
        block.parent = self
        return block
    }
}

