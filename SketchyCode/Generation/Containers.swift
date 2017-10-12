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

extension Scope: VariableContainer {
    var contained: Set<VariableRef> {
        return Set(children
            .flatMap { ($0 as? VariableContainer) }
            .flatMap { $0.contained })
    }
}

extension Generator {
    func allGenerators() -> [Generator] {
        if let container = self as? Scope {
            return container.children
        } else {
            return [self]
        }
    }
}
