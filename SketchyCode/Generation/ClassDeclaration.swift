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
        self.selfDeclaration.value.hints = [.isSelf]
        self.inheriting = inheriting
        super.init()
        add(selfDeclaration)
    }
}

extension ClassDeclaration {

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
        variable.value = VariableRef(identifier: variable.value.identifier, type: type, hints: [])
        return cls
    }

    func makeClass(ofType type: TypeRef, inheriting: TypeRef? = nil) -> ClassDeclaration {
        let cls = ClassDeclaration(
            typeRef: type,
            inheriting: inheriting)
        add(cls)
        return cls
    }

    func moveExpressions(for variable: VariableDeclaration, to cls: ClassDeclaration) {
        var movedExpressions: [Generator] = []
        for (index, child) in children.enumerated().reversed() {
            guard let expression = child as? VariableMutation & Generator else { continue }

            // This does not work because of more complex lookup rules with nested variables
            //guard expression.contained.contains(variable.value) else { continue }
            children.remove(at: index)
            let transferred = expression.transform(
                variable: variable.value,
                to: cls.selfDeclaration.value)
            movedExpressions.insert(transferred, at: 0)
        }
        cls.add(contentsOf: movedExpressions)
    }
}

extension ClassDeclaration {

    func moveExpressionsToPropertyClosures() {
        for variableDeclaration in children.flatMap({ $0 as? VariableDeclaration }) {
            // Skip self variables
            guard variableDeclaration.value != selfDeclaration.value else { continue }
            moveExpressionsToPropertyClosures(for: variableDeclaration)
        }
    }

    func moveExpressionsToPropertyClosures(for variable: VariableDeclaration) {
        var movedExpressions: [VariableMutation & Generator] = []
        for (index, child) in children.enumerated().reversed() {
            guard let expression = child as? VariableMutation & Generator else { continue }
            // Only move expressions that are isolated.
            // FIXME: Improve to expressions that only contain non-class-contained variables.
            guard expression.contained.count == 1 && expression.contained.contains(variable.value) else { continue }
            children.remove(at: index)
            movedExpressions.insert(expression, at: 0)
        }
        variable.moveToInitializer(expressions: movedExpressions, from: self)
    }

    func moveExpressionsToInitializer() {
        var movedExpressions: [VariableMutation & Generator] = []
        for (index, child) in children.enumerated().reversed() {
            guard let expression = child as? VariableMutation & Generator else { continue }
            children.remove(at: index)
            movedExpressions.insert(expression, at: 0)
        }
        var options: DeclarationOptions = []
        let parameters = inheriting?.requiredInitializerParameters ?? []
        if let inheriting = inheriting {
            options.insert(.overrideDeclaration)
            movedExpressions.insert(BasicExpression(.s("super.init()")), at: 0)
            if inheriting.conformsToNSCoding {
                let function = FunctionDeclaration(
                    initializerWith: [.requiredDeclaration],
                    parameters: [Parameter(tag: "coder", variable: VariableRef(ofType: "NSCoder"))],
                    block: makeBlock(children: [BasicExpression(.s("fatalError(\"Not implemented\")"))])
                )
                children.append(function)
            }
        }
        let function = FunctionDeclaration(
            initializerWith: options,
            parameters: parameters,
            block: makeBlock(children: movedExpressions))
        children.append(function)
    }
}
