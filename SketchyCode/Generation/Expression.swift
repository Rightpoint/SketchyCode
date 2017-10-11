//
//  Expression.swift
//  SketchyCode
//
//  Created by Brian King on 10/4/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// Calling this an expression is a bit of an exaggeration. This takes place of
// statements and expressions, and performs minimal modeling by design. The goal
// is to provide a loose modeling that defers variable naming and allows the
// generators to probe dependencies and move expressions for organizational
// purposes.

protocol Expression: Generator {
    var dependent: [VariableRef] { get }

    func transform(variable: VariableRef, to toVariable: VariableRef) -> Expression
}

// SyntaxPart is a simple DSL to build expressions.
indirect enum SyntaxPart {
    case s(String)
    case v(VariableRef)
    // wrap an object in `()`
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

// PartExpression protocol is a utility protocol
protocol PartExpression: Expression {
    var parts: [SyntaxPart] { get }
}

extension PartExpression {
    var dependent: [VariableRef] {
        return parts.flatMap { $0.variableRef }
    }
}

// This is really the default function for a `PartExpression`s `Generate`
// conformance, but broken out since one does not simply invoke default
// implementations.
extension Scope {
    func generate(parts: [SyntaxPart], writer: Writer) throws {
        let line = try parts
            .enumerated()
            .map { (index, part) -> String in
                return try part.generate(in: self, isFirstToken: index == 0)
            }
            .joined()
        writer.append(line: line)
    }
}

extension SyntaxPart {
    func generate(in context: Scope, isFirstToken: Bool) throws -> String {
        switch self {
        case .v(let object):
            return try context.name(for: object, isLeadingVariable: isFirstToken)
        case .s(let string):
            return string
        case .p(let object):
            let obj = try SyntaxPart.v(object).generate(in: context, isFirstToken: false)
            return "(\(obj))"
        case .debug(let part):
            return try part.generate(in:context, isFirstToken:isFirstToken)
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

struct SimpleExpression: PartExpression {
    let parts: [SyntaxPart]

    func generate(in context: Scope, writer: Writer) throws {
        try context.generate(parts: parts, writer: writer)
    }

    func transform(variable from: VariableRef, to: VariableRef) -> Expression {
        return SimpleExpression(parts: parts.map { $0.transform(variable: from, to: to) })
    }
}

struct AssignmentExpression: PartExpression {
    let to: VariableRef
    let parts: [SyntaxPart]

    func generate(in context: Scope, writer: Writer) throws {
        let toName = try context.name(for: to, isLeadingVariable: false)
        writer.append(line: "\(toName) = ", addNewline: false)
        try context.generate(parts: parts, writer: writer)
    }

    func transform(variable from: VariableRef, to: VariableRef) -> Expression {
        return AssignmentExpression(
            to: to.transform(from: from, to: to),
            parts: parts.map { $0.transform(variable: from, to: to) })
    }
}

extension SimpleExpression {
    init(_ parts: SyntaxPart...) {
        self.parts = parts
    }
}

extension AssignmentExpression {
    init(to: VariableRef, _ parts: SyntaxPart...) {
        self.to = to
        self.parts = parts
    }
}

