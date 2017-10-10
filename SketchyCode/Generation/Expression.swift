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

protocol Expression {
    var dependent: [VariableRef] { get }
}

// SyntaxPart is a simple DSL to build expressions.
indirect enum SyntaxPart {
    case s(String)
    case v(VariableRef)
    // wrap an object in `()`
    case p(VariableRef)
    // Debug helper
    case debug(SyntaxPart)
}

// PartExpression protocol is a utility protocol
protocol PartExpression: Expression, Generator {
    var parts: [SyntaxPart] { get }
}

extension PartExpression {
    var dependent: [VariableRef] {
        return parts.flatMap {
            if case .v(let variable) = $0 {
                return variable
            }
            return nil
        }
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

struct SimpleExpression: PartExpression {
    let parts: [SyntaxPart]
    init(_ parts: SyntaxPart...) {
        self.parts = parts
    }

    func generate(in context: Scope, writer: Writer) throws {
        try context.generate(parts: parts, writer: writer)
    }
}

struct AssignmentExpression: PartExpression {
    let to: VariableRef
    let parts: [SyntaxPart]
    init(to: VariableRef, _ parts: SyntaxPart...) {
        self.to = to
        self.parts = parts
    }

    func generate(in context: Scope, writer: Writer) throws {
        let toName = try context.name(for: to, isLeadingVariable: false)
        writer.append(line: "\(toName) = ", addNewline: false)
        try context.generate(parts: parts, writer: writer)
    }
}

