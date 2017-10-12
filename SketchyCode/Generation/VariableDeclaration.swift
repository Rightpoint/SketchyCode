//
//  VariableDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class VariableDeclaration {
    var value: VariableRef
    var initialization: AssignmentExpression?
    init(type: TypeRef, expression: Generator? = nil) {
        self.value = VariableRef(uuid: UUID(), type: type)
        if let expression = expression {
            self.initialization = AssignmentExpression(to: value, expression: expression)
        }
    }
}

extension VariableDeclaration {

    func moveToInitializer(expressions: [VariableMutation & Generator], from: Scope) {
        // Nothing to do for no expressions
        guard expressions.count > 0 else { return }

        // Create a new variable declaration to represent the variable inside the closure
        let variable = VariableDeclaration(type: value.type)

        // Move all the expressions to the new variable
        var expressions = transform(generators: expressions, from: value, to: variable.value)
        var existingExpressions = initialization?.expression.allGenerators() ?? []
        existingExpressions = transform(generators: existingExpressions, from: value, to: variable.value)

        // Grab the first expression for the initialization
        let initializationExpression = existingExpressions.count > 0 ?
            existingExpressions.removeFirst() :
            expressions.removeFirst()

        variable.initialization = AssignmentExpression(to: variable.value, expression: initializationExpression)

        // Build up the expressions for the new block expression
        existingExpressions.insert(variable, at: 0)
        existingExpressions.append(contentsOf: expressions)
        existingExpressions.append(BasicExpression(.s("return "), .v(variable.value)))

        initialization = AssignmentExpression(
            to: value,
            expression: from.makeBlock(children: existingExpressions))
    }
}

extension Scope {

    // FIXME: Replace initializedWith with an InitializationExpression that will infer types
    func makeVariable(ofType type: TypeRef, initializedWith generator: Generator) -> VariableDeclaration {
        let variable = VariableDeclaration(type: type, expression: generator)
        add(variable)
        return variable
    }
}

