//
//  NamingStrategy.swift
//  SketchyCode
//
//  Created by Brian King on 10/5/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// A naming strategy is resposible for creating names for declarations.
protocol NamingStrategy {
    func name(for variable: VariableRef, in scope: Scope) throws -> String
}

class SwiftUIKitNamingStrategy: NamingStrategy {

    func name(for variable: VariableRef) -> String {
        if variable.isSelf {
            return "self"
        }
        if let hint = variable.userVariableName {
            return hint
        }
        let typeName = variable.type.name
        var name = typeName
        if name.hasPrefix("UI") {
            name.removeFirst()
            name.removeFirst()
        }
        if let first = name.indices.first {
            name.replaceSubrange(first...first, with: String(name[first]).lowercased())
        }
        return name
    }

    func lookupName(for variable: VariableRef, in scope: Scope) -> String {
        var searchScope: Scope? = scope
        var name: String? = nil
        while let currentScope = searchScope, name == nil {
            name = currentScope.registeredVariables[variable.identifier]
            searchScope = currentScope.parent
        }
        if let name = name {
            return name
        }

        // Register a new name with this scope
        let generatedName = self.name(for: variable)
        var counter = 1
        var newName = generatedName
        // Add a counter if needed
        while scope.registeredVariables.values.contains(newName) {
            counter += 1
            newName = "\(generatedName)\(counter)"
        }
        scope.registeredVariables[variable.identifier] = newName
        return newName
    }

    func name(for variable: VariableRef, in scope: Scope) throws -> String {
        var path: [VariableRef] = scope.path(for: variable)
        var nextScope = scope.parent
        while path.count == 0 {
            if let scope = nextScope {
                path = scope.path(for: variable)
                nextScope = scope.parent
            } else {
                _ = scope.path(for: variable)
                throw UnregisteredVariableRefError(variable: variable)
            }
        }
        assert(path.last == variable)
        var variableNames: [String] = []
        for variable in path {
            guard !variable.isImplicitSelf else { continue }
            variableNames.append(lookupName(for: variable, in: scope))
        }
        var name = variableNames.joined(separator: ".")
        if variable.isLeading && variableNames.count > 0 {
            name.append(".")
        }
        return name
    }

}

extension SyntaxPart {
    func code(in scope: Scope, with namingStrategy: NamingStrategy) throws -> String {
        switch self {
        case .v(let variable):
            return try namingStrategy.name(for: variable, in: scope)
        case .s(let string):
            return string
        case .c(let type, let string):
            if type.name == "String" {
                return "\"\(string)\""
            } else {
                return string
            }
        case .p(let variable):
            return "(\(try namingStrategy.name(for: variable, in: scope)))"
        case .debug(let part):
            return try part.code(in: scope, with: namingStrategy)
        }
    }
}
