//
//  AssignmentExpression.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// An assignment expression is attached to a variable declaration.
struct AssignmentExpression: Generator {
    let to: VariableRef
    let expression: Generator

    func generate(in scope: Scope, context: GeneratorContext) throws {
        try expression.generate(in: scope, context: context)
    }

}

extension AssignmentExpression {
    init(to: VariableRef, expression parts: SyntaxPart...) {
        self.init(to: to, expression: BasicExpression(parts: parts))
    }
}
