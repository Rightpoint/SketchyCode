//
//  GeneratorContext.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct GeneratorOptions {
    var generatePropertyClosures: Bool = true
}

class GeneratorContext {
    let writer: Writer = Writer()
    var namingStrategy: NamingStrategy
    var options: GeneratorOptions

    init(namingStrategy: NamingStrategy, options: GeneratorOptions) {
        self.namingStrategy = namingStrategy
        self.options = options
    }

    func code(in scope: Scope, for syntaxPart: SyntaxPart) throws -> String {
        switch syntaxPart {
        case .v(let object):
            return try name(in: scope, for: object)
        case .s(let string):
            return string
        case .c(let type, let string):
            if type.name == "String" {
                return "\"\(string)\""
            } else {
                return string
            }
        case .p(let object):
            let variable = try name(in: scope, for: object)
            return "(\(variable))"
        case .debug(let part):
            return try code(in: scope, for: part)
        }
    }

    func name(in scope: Scope, for variable: VariableRef) throws -> String {
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
            if !variable.isImplicitSelf {
                variableNames.append(namingStrategy.name(for: variable))
            }
        }
        var name = variableNames.joined(separator: ".")
        if variable.isLeading && variableNames.count > 0 {
            name.append(".")
        }
        return name
    }
}
