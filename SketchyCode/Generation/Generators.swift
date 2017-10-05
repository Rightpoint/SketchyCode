//
//  Generators.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// This the simplest decomposition of a method invocation. Values only need
// to be referenced by `case object` if it is managed by generation
enum SyntaxPart {
    case string(String)
    case object(Object)
}

protocol Generator {
    var provides: Object? { get }
    var dependent: [Object] { get }

    func generate(in context: DeclarationContext, writer: Writer) throws
}

struct CommandGenerator {
    let provides: Object?
    let parts: [SyntaxPart]
    init(provides: Object? = nil, _ parts: SyntaxPart...) {
        self.provides = provides
        self.parts = parts
    }
}

extension SyntaxPart {

    func generate(in context: DeclarationContext, implicitSelf: Bool) throws -> String {
        switch self {
        case .object(let object):
            let reference = try context.reference(for: object)
            switch (implicitSelf, reference.isSelf) {
            case (true, true):
                return ""
            case (false, true):
                return "self"
            case (true, false):
                return reference.name.appending(".")
            case (false, false):
                return reference.name
            }
        case .string(let string):
            return string
        }
    }
}

extension CommandGenerator: Generator {
    var dependent: [Object] {
        return parts.flatMap {
            if case .object(let object) = $0 {
                return object
            }
            return nil
        }
    }

    func generate(in context: DeclarationContext, writer: Writer) throws {
        var line = try parts
            .enumerated()
            .map { (arg) -> String in
                let (index, part) = arg
                return try part.generate(in: context, implicitSelf: index == 0)
            }
            .joined()
        if let provides = provides {
            let ref = try context.reference(for: provides)
            line = "let \(ref.name) = \(line)"
        }
        writer.append(line: line)
    }
}
