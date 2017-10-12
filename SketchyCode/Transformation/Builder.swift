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



struct SwiftUIKitBuilder: Builder {
    func build(layer: MSShapeLayer, in scope: Scope) throws -> VariableDeclaration? {
        // Skip layers with no TypeRef
        guard let name = className(for: layer) else { return nil }
        let variable = scope.makeVariable(
            ofType: TypeRef(name: name),
            initializedWith: BasicExpression(.s(name.appending("()"))))

        scope.add(expression: .v(variable.value), .s("frame = \(layer.frame.asCGRect())"))

        if let layer = layer as? LayerContainer {
            for childVariable in try layer.layers.flatMap({ try build(layer: $0, in: scope) }) {
                scope.add(BasicExpression(.v(variable.value), .s("addSubview"), .p(childVariable.value)))
            }
        }
        return variable
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
}

extension MSRect {
    func asCGRect() -> String {
        return "CGRect(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}
