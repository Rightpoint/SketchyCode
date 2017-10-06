//
//  Expression.swift
//  SketchyCode
//
//  Created by Brian King on 10/4/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// Calling this an expression is a bit of an exaggeration. This takes place of
// statements and expressions, and performs minimal modeling of the expression.
// Everything that can be is modeled by a string, except objects that are managed
// by the generation process are modeled here.

protocol Expression {
    var dependent: [Object] { get }
}

enum SyntaxPart {
    case string(String)
    case object(Object)
    case p(Object)
}

protocol PartExpression: Expression, Generator {
    var parts: [SyntaxPart] { get }
}

extension PartExpression {

    var dependent: [Object] {
        return parts.flatMap {
            if case .object(let object) = $0 {
                return object
            }
            return nil
        }
    }
}

extension DeclarationContext {
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

    func generate(in context: DeclarationContext, isFirstToken: Bool) throws -> String {
        switch self {
        case .object(let object):
            return try object.generate(in: context, isFirstToken: isFirstToken)
        case .string(let string):
            return string
        case .p(let object):
            let obj = try SyntaxPart.object(object).generate(in: context, isFirstToken: false)
            return "(\(obj))"
        }
    }
}

struct SimpleExpression: PartExpression {
    let parts: [SyntaxPart]
    init(_ parts: SyntaxPart...) {
        self.parts = parts
    }

    func generate(in context: DeclarationContext, writer: Writer) throws {
        try context.generate(parts: parts, writer: writer)
    }
}

struct AssignmentExpression: PartExpression {
    let to: Object
    let parts: [SyntaxPart]
    init(to: Object, _ parts: SyntaxPart...) {
        self.to = to
        self.parts = parts
    }

    func generate(in context: DeclarationContext, writer: Writer) throws {
        let toName = try to.generate(in: context, isFirstToken: false)
        writer.append(line: "\(toName) = ", addNewline: false)
        try context.generate(parts: parts, writer: writer)
    }
}

