//
//  BasicExpression.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct BasicExpression: Generator {
    let parts: [SyntaxPart]

    init(parts: [SyntaxPart]) {
        var parts = parts
        if var first = parts.first {
            first.addLeadingHint()
            parts[0] = first
        }
        self.parts = parts
    }

    func generate(in scope: Scope, context: GeneratorContext) throws {
        context.writer.append(line: try parts
            .map { part -> String in
                return try context.code(in: scope, for: part)
            }
            .joined())
    }
}

// SyntaxPart is a simple DSL to build "expressions".
indirect enum SyntaxPart {
    case s(String)
    case v(VariableRef)
    // wrap a variable in `()`
    case p(VariableRef)
    // Debug helper
    case debug(SyntaxPart)

    var variableRef: VariableRef? {
        switch self {
        case .s: return nil
        case .v(let variable): return variable
        case .p(let variable): return variable
        case .debug(let part): return part.variableRef
        }
    }

    mutating func addLeadingHint() {
        switch self {
        case .s:
            break
        case .v(var variable):
            variable.addLeadingHint()
            self = .v(variable)
        case .p(var variable):
            variable.addLeadingHint()
            self = .v(variable)
        case .debug(var part):
            part.addLeadingHint()
        }
    }
}

extension BasicExpression {
    init(_ parts: SyntaxPart...) {
        self.init(parts: parts)
    }
}

extension VariableRef {
    mutating func addLeadingHint() {
        guard !isLeading else { return }
        self.hints = self.hints + [.isLeading]
    }
}
