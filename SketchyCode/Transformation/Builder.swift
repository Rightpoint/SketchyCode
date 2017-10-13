//
//  Builder.swift
//  SketchyCode
//
//  Created by Brian King on 10/12/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol Builder {
    func build(layer: MSShapeLayer, in scope: Scope) throws -> VariableDeclaration?
}

class SwiftUIKitBuilder: Builder {
    // Skip layers with no TypeRef

    func build(layer: MSShapeLayer, in scope: Scope) throws -> VariableDeclaration? {
        let hint = try GenerationHint.makeHint(input: layer.name, objectID: layer.objectID)
        if let className = className(for: layer) {

            let variable = scope.makeVariable(ofType: TypeRef(name: className), initializedWith: nil)

            var generationScope = scope
            if let subClass = hint.className {
                generationScope = scope.makeClass(ofType: TypeRef(name: subClass + "View"), for: variable)
            }


            variable.initialization = AssignmentExpression(to: variable.value, expression:
                BasicExpression(.s(className.appending("()"))))

//            generationScope.add(expression: .v(variable.value), .s("accessibilityIdentifier = \""), .v(variable.value), .s("\""))

            configureFrameLayout(variable.value, in: generationScope, layer: layer)
            try configureChildren(variable.value, in: generationScope, layer: layer)
            if let classDeclaration = generationScope as? ClassDeclaration {
//                scope.moveExpressions(for: variable, to: classDeclaration)
                classDeclaration.moveExpressionsToPropertyClosures()
            }
            return variable
        } else {
            try configureChildren(nil, in: scope, layer: layer)
        }

        return nil
    }

    func configureFrameLayout(_ variableRef: VariableRef, in scope: Scope, layer: MSShapeLayer) {
        scope.add(expression: .v(variableRef), .s("frame = \(layer.frame.asCGRect())"))
        let options = ResizeOptions(rawValue: Int(layer.resizingConstraint))
        scope.add(expression: .v(variableRef), .s("autoresizingMask = \(resizingMask(from: options))"))
    }

    func configureChildren(_ variableRef: VariableRef?, in scope: Scope, layer: MSShapeLayer) throws {
        if let layer = layer as? LayerContainer {
            for childVariable in try layer.layers.flatMap({ try build(layer: $0, in: scope) }) {
                if let variableRef = variableRef {
                    scope.add(BasicExpression(.v(variableRef), .s("addSubview"), .p(childVariable.value)))
                }
            }
        }
    }

    func className(for shapeLayer: MSShapeLayer) -> String? {
        switch shapeLayer {
        case is MSTextLayer:
            return "UILabel"
        case is MSLayerGroup:
            return "UIView"
        case is MSBitmapLayer:
            return "UIImageView"
        case let shapeGroup as MSShapeGroup where
                shapeGroup.layers.count == 1 &&
                shapeGroup.layers[0] is MSRectangleShape:
            return "UIView"
        default:
            return nil
        }
    }

    func resizingMask(from options: ResizeOptions) -> String {
        var value = Array<String>()
        if options.contains(.flexibleLeftMargin) { value.append(".flexibleLeftMargin")}
        if options.contains(.flexibleWidth) { value.append(".flexibleWidth")}
        if options.contains(.flexibleRightMargin) { value.append(".flexibleRightMargin")}
        if options.contains(.flexibleTopMargin) { value.append(".flexibleTopMargin")}
        if options.contains(.flexibleHeight) { value.append(".flexibleHeight")}
        if options.contains(.flexibleBottomMargin) { value.append(".flexibleBottomMargin")}
        return "[\(value.joined(separator: ", "))]"
    }
}
