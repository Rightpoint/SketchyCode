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

protocol Expression: Generator {
    func transform(variable: VariableRef, to toVariable: VariableRef) -> Expression
}
