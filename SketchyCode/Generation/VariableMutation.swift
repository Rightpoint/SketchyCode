//
//  VariableMutation.swift
//  SketchyCode
//
//  Created by Brian King on 10/4/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// This protocol defines a contract to lookup and move protocols
protocol VariableMutation {
    var contained: [VariableRef] { get }
    func transform(variable: VariableRef, to toVariable: VariableRef) -> Self
}

extension BasicExpression: VariableMutation {
    var contained: [VariableRef] {
        return parts.flatMap { $0.variableRef }
    }

    func transform(variable from: VariableRef, to: VariableRef) -> BasicExpression {
        return BasicExpression(parts: parts.map { $0.transform(variable: from, to: to) })
    }
}

extension AssignmentExpression: VariableMutation {
    var contained: [VariableRef] {
        let exprContained = (expression as? VariableMutation)?.contained ?? []
        return exprContained + [to]
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

extension BlockExpression: VariableMutation {
    var contained: [VariableRef] {
        return children
            .flatMap { ($0 as? VariableMutation) }
            .flatMap { $0.contained }
    }

    func transform(variable from: VariableRef, to toVariable: VariableRef) -> BlockExpression {
        let transformed = children.map { (child) -> Generator in
            if let expr = child as? VariableMutation & Generator {
                return expr.transform(variable: from, to: toVariable)
            } else {
                return child
            }
        }
        return BlockExpression(children: transformed)
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
