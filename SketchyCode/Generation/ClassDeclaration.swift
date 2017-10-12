//
//  ClassDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class ClassDeclaration: Scope {
    let selfDeclaration: VariableDeclaration
    let inheriting: TypeRef?

    init(typeRef: TypeRef, inheriting: TypeRef? = nil) {
        self.selfDeclaration = VariableDeclaration(type: typeRef)
        self.inheriting = inheriting
        super.init()
        add(selfDeclaration)
    }
}

extension ClassDeclaration {

    func isSelf(ref: VariableRef) -> Bool {
        return selfDeclaration.value == ref
    }

    func contains(variable: VariableRef) -> Bool {
        return path(for: variable).count > 0
    }

    func contains(anyOf variables: [VariableRef]) -> Bool {
        for variable in variables {
            if contains(variable: variable) {
                return true
            }
        }
        return false
    }

    var typeRef: TypeRef {
        return selfDeclaration.value.type
    }
}


extension Scope {

    func makeClass(ofType type: TypeRef, for variable: VariableDeclaration) -> ClassDeclaration {
        let cls = ClassDeclaration(
            typeRef: type,
            inheriting: variable.value.type)
        add(cls)
        variable.value = VariableRef(uuid: variable.value.uuid, type: type)
        return cls
    }

    func moveExpressions(for variable: VariableDeclaration, to cls: ClassDeclaration) {
        var movedExpressions: [Generator] = []
        for (index, child) in children.enumerated().reversed() {
            guard let expression = child as? VariableMutation else { continue }

            children.remove(at: index)
            guard let transferred = expression.transform(
                variable: variable.value,
                to: cls.selfDeclaration.value) as? Generator else {
                    fatalError("\(VariableMutation.self) \(child) does not conform to \(Generator.self)")
            }
            movedExpressions.insert(transferred, at: 0)
        }
        cls.add(contentsOf: movedExpressions)
    }
}

extension ClassDeclaration {

    func moveExpressionsToPropertyClosures(for variable: VariableDeclaration) {
        for (index, child) in children.enumerated().reversed() {
        }
    }
}
