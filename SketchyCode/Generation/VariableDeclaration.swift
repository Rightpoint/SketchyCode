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
    init(type: TypeRef, initialization: AssignmentExpression? = nil) {
        self.value = VariableRef(uuid: UUID(), type: type)
        self.initialization = initialization
    }
}

extension Scope {
    func makeVariable(ofType type: TypeRef) -> VariableDeclaration {
        let variable = VariableDeclaration(type: type)
        add(variable)
        return variable
    }
}

