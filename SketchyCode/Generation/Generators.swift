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

extension ClassDeclaration: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        if let inheriting = inheriting {
            context.writer.append(line: "class \(typeRef.name): \(inheriting.name) ", addNewline: false)
        } else {
            context.writer.append(line: "class \(typeRef.name) ", addNewline: false)
        }
        try context.writer.block() {
            try children.forEach { try $0.generate(in: self, context: context) }
        }
    }
}

extension VariableDeclaration: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        if let classDeclaration = scope as? ClassDeclaration, classDeclaration.selfDeclaration.value == self.value {
            return
        }
        let name = try context.name(in: scope, for: value)

        if let initialization = initialization {
            context.writer.append(line: "let \(name): \(value.type.name) = ", addNewline: false)
            try initialization.generate(in: try scope.nonTypeScope(), context: context)
        } else {
            context.writer.append(line: "let \(name): \(value.type.name)")
        }
    }
}

extension FunctionDeclaration: Generator {

    var swiftPrefix: String {
        switch definition {
        case .initializer: return "\(options.swiftPrefix)init"
        case .function(let name, _): return "\(options.swiftPrefix)func \(name)"
        }
    }

    var swiftSuffix: String {
        switch definition {
        case .initializer: return ""
        case .function(_, let result):
            return result.isVoid ? "" : " -> \(result.name)"
        }
    }

    func generate(in scope: Scope, context: GeneratorContext) throws {
        let parameters = self.parameters.map { $0.swiftRepresentation }.joined(separator: ", ")
        context.writer.append(line: "\(swiftPrefix)(\(parameters))\(swiftSuffix) ", addNewline: false)
        try block.generate(in: scope, context: context)
    }
}

extension BasicExpression: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        context.writer.append(line: try parts
            .map { part -> String in
                return try context.code(in: scope, for: part)
            }
            .joined())
    }
}

extension BlockExpression: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        try context.writer.block(appending: "\(invoke ? "()" : "")") {
            try children.forEach { try $0.generate(in: self, context: context) }
        }
    }
}

extension GlobalScope: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        context.writer.append(line: "// Automatically generated. Do Not Edit!")
        // Generate ClassDeclarations first.
        try children.forEach {
            if $0 is ClassDeclaration {
                try $0.generate(in: self, context: context)
            }
        }
        try children.forEach {
            if !($0 is ClassDeclaration) {
                try $0.generate(in: self, context: context)
            }
        }
    }
}

extension Generator where Self: Scope {
    func generate(context: GeneratorContext) throws {
        try generate(in: self, context: context)
    }
}
