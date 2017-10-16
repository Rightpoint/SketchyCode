//
//  FunctionDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/15/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct Parameter {
    let tag: String
    var variable: VariableRef
    let _name: String?

    init(tag: String, variable: VariableRef, name: String? = nil) {
        self.tag = tag
        self.variable = variable
        self._name = name
    }

    var name: String {
        return _name ?? tag
    }

    var swiftRepresentation: String {
        return "\(tag): \(variable.type.name)"
    }
}
struct DeclarationOptions: OptionSet {
    var rawValue: Int
    static var publicDeclaration = DeclarationOptions(rawValue: 1 << 0)
    static var overrideDeclaration = DeclarationOptions(rawValue: 1 << 1)
    static var requiredDeclaration = DeclarationOptions(rawValue: 1 << 2)

    var swiftPrefix: String {
        var values: [String] = []
        if contains(.publicDeclaration) { values.append("public") }
        if contains(.overrideDeclaration) { values.append("override") }
        if contains(.requiredDeclaration) { values.append("required") }
        if values.count > 0 { values.append("") }
        return values.joined(separator: " ")
    }
}

class FunctionDeclaration {
    enum Definition {
        case initializer
        case function(name: String, result: TypeRef)
    }
    let definition: Definition
    var options: DeclarationOptions
    var parameters: [Parameter]
    var block: BlockExpression

    init(name: String, options: DeclarationOptions, parameters: [Parameter], result: TypeRef, block: BlockExpression) {
        self.definition = .function(name: name, result: result)
        self.options = options
        self.parameters = parameters
        self.block = block
        block.invoke = false
    }

    init(initializerWith options: DeclarationOptions, parameters: [Parameter], block: BlockExpression) {
        self.definition = .initializer
        self.options = options
        self.parameters = parameters
        self.block = block
        block.invoke = false
    }
}
