//
//  Generators.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws
}

struct GeneratorOptions: OptionSet {
    let rawValue: Int
}

class GeneratorContext {
    let writer: Writer = Writer()
    var namingStrategy: NamingStrategy
    var options: GeneratorOptions = []

    init(namingStrategy: NamingStrategy, options: GeneratorOptions) {
        self.namingStrategy = namingStrategy
        self.options = options
    }

    func code(in scope: Scope, for syntaxPart: SyntaxPart, isLeadingVariable: Bool) throws -> String {
        switch syntaxPart {
        case .v(let object):
            return try name(in: scope, for: object, isLeadingVariable: isLeadingVariable)
        case .s(let string):
            return string
        case .p(let object):
            let variable = try name(in: scope, for: object, isLeadingVariable: false)
            return "(\(variable))"
        case .debug(let part):
            return try code(in: scope, for: part, isLeadingVariable: isLeadingVariable)
        }
    }

    func name(in scope: Scope, for variable: VariableRef, isLeadingVariable: Bool) throws -> String {
        var path: [VariableRef] = scope.path(for: variable)
        var nextScope = scope.parent
        while path.count == 0 {
            if let scope = nextScope {
                path = scope.path(for: variable)
                nextScope = scope.parent
            } else {
                struct UnregisteredVariableRefError: Error {
                    let variable: VariableRef
                }
                _ = scope.path(for: variable)
                throw UnregisteredVariableRefError(variable: variable)
            }
        }
        assert(path.last == variable)
        let classDeclaration: ClassDeclaration? = scope.lookupContainer(where: { _ in true })
        let isSelfRef: Bool = classDeclaration?.isSelf(ref: variable) ?? false
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
