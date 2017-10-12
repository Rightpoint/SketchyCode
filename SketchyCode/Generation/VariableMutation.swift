//
//  VariableMutation.swift
//  SketchyCode
//
//  Created by Brian King on 10/4/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// This protocol defines a contract to lookup and move protocols
protocol VariableMutation: VariableContainer {
    func transform(variable: VariableRef, to toVariable: VariableRef) -> Self
}

extension BasicExpression: VariableMutation {
    var contained: Set<VariableRef> {
        return Set(parts.flatMap { $0.variableRef })
    }

    func transform(variable from: VariableRef, to: VariableRef) -> BasicExpression {
        return BasicExpression(parts: parts.map { $0.transform(variable: from, to: to) })
    }
}

extension AssignmentExpression: VariableMutation {
    var contained: Set<VariableRef> {
        var exprContained = Set((expression as? VariableMutation)?.contained ?? [])
        exprContained.insert(to)
        return exprContained
    }

    func transform(variable from: VariableRef, to: VariableRef) -> AssignmentExpression {
        let transformed: Generator
        if let expression = expression as? VariableMutation & Generator {
            transformed = expression.transform(variable: from, to: to)
        } else {
            transformed = expression
        }
        return AssignmentExpression(
            to: to.transform(variable: from, to: to),
            expression: transformed)
    }
}

// Generator is a poluted term in Collection, so use a free function instead
func transform(generators: [Generator], from: VariableRef, to toVariable: VariableRef) -> [Generator] {
    return generators.map { (child) -> Generator in
        if let expr = child as? VariableMutation & Generator {
            return expr.transform(variable: from, to: toVariable)
        } else {
            return child
        }
    }
}

extension BlockExpression: VariableMutation {

    func transform(variable from: VariableRef, to toVariable: VariableRef) -> BlockExpression {
        let transformed = SketchyCode.transform(generators: children, from: from, to: toVariable)

        return try! parentConext().makeBlock(children: transformed)
    }
}

extension VariableRef {
    func transform(variable: VariableRef, to: VariableRef) -> VariableRef {
        if self == variable {
            return to
        }
        return self
    }
}

extension SyntaxPart {
    func transform(variable: VariableRef, to: VariableRef) -> SyntaxPart {
        switch self {
        case .v(let v):
            return .v(v.transform(variable: variable, to: to))
        case .p(let v):
            return .p(v.transform(variable: variable, to: to))
        case .debug(let inner):
            return .debug(inner.transform(variable: variable, to: to))
        default:
            return self
        }
    }
}
