//
//  BasicExpression.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct BasicExpression: Generator, Expression {
    let parts: [SyntaxPart]

    func generate(in scope: Scope, context: GeneratorContext) throws {
        context.writer.append(line: try parts
            .enumerated()
            .map { (index, part) -> String in
                return try context.code(in: scope, for: part, isLeadingVariable: index == 0)
            }
            .joined())
    }

    func transform(variable from: VariableRef, to: VariableRef) -> Expression {
        return BasicExpression(parts: parts.map { $0.transform(variable: from, to: to) })
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
}


extension VariableRef {
    func transform(from: VariableRef, to: VariableRef) -> VariableRef {
        if self == from {
            return to
        }
        return self
    }
}

extension SyntaxPart {
    func transform(variable from: VariableRef, to: VariableRef) -> SyntaxPart {
        switch self {
        case .v(let variable):
            return .v(variable.transform(from: from, to: to))
        case .p(let variable):
            return .p(variable.transform(from: from, to: to))
        case .debug(let inner):
            return .debug(inner.transform(variable: from, to: to))
        default:
            return self
        }
    }
}

extension BasicExpression {
    init(_ parts: SyntaxPart...) {
        self.parts = parts
    }
}
