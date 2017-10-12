//
//  VariableContainer.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol VariableContainer {
    var contained: Set<VariableRef> { get }
}

extension GeneratorContainer {
    var contained: Set<VariableRef> {
        return Set(children
            .flatMap { ($0 as? VariableContainer) }
            .flatMap { $0.contained })
    }
}

extension Scope: VariableContainer {}
extension BlockExpression: VariableContainer {}

protocol GeneratorContainer {
    var children: [Generator] { get }
}

extension Scope: GeneratorContainer {}
extension BlockExpression: GeneratorContainer {}
