//
//  BlockExpression.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class BlockExpression: Expression {
    var children: [Generator]

    init(children: [Generator] = []) {
        self.children = children
    }

    var hasContent: Bool {
        return children.count > 0
    }

    func transform(variable: VariableRef, to toVariable: VariableRef) -> Expression {
        let transformed = children.map { (child) -> Generator in
            if let expr = child as? Expression {
                return expr.transform(variable: variable, to: toVariable)
            } else {
                return child
            }
        }
        return BlockExpression(children: transformed)
    }

    func generate(in scope: Scope, context: GeneratorContext) throws {
        try context.writer.block(appending: "()") {
            try children.forEach { try $0.generate(in: scope, context: context) }
        }
    }
}
