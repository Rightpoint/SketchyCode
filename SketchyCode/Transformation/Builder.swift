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

    func build(layer: MSShapeLayer, in scope: Scope) throws -> VariableDeclaration? {
        let hint = try GenerationHint.makeHint(input: layer.name, objectID: layer.objectID)
        if let className = className(for: layer) {

            var variable = scope.makeVariable(ofType: TypeRef(name: className), initializedWith: nil)

            var generationScope = scope
            var inCustomClass = false
            if let subClass = hint.className {
                let classDeclaration = scope.makeClass(ofType: TypeRef(name: subClass + "View"), for: variable)
                variable = classDeclaration.selfDeclaration
                generationScope = classDeclaration
                inCustomClass = true
            }

            if let variableName = hint.variableName {
                variable.value.hints.append(.userHint(variableName))
                generationScope.add(expression: .v(variable.value), .s("accessibilityIdentifier = \"\(variableName)\""))
            }


            variable.initialization = AssignmentExpression(to: variable.value, expression:
                BasicExpression(.s(className.appending("()"))))


            configureFrameLayout(variable.value, in: generationScope, layer: layer)
            if let style = layer as? Styled {
                configureStyle(variable.value, in: generationScope, style: style.style)
            }
            if let textLayer = layer as? MSTextLayer {
                configureLabel(variable.value, in: generationScope, attributedString: textLayer.attributedString)
            }
            try configureChildren(variable.value, in: generationScope, layer: layer)
            if let classDeclaration = generationScope as? ClassDeclaration, inCustomClass {
                classDeclaration.moveExpressionsToPropertyClosures()
                classDeclaration.moveExpressionsToInitializer()
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

    func configureStyle(_ variableRef: VariableRef, in scope: Scope, style: MSStyle) {
        for attribute in style.enabledAttributes {
            switch attribute {
            case let fill as MSStyleFill:
                // 1: Gradient -- Skip for now
                if fill.fillType == 1 { return }
                assert(fill.fillType == 0, "Only solid fill is supported")
                scope.add(expression: .v(variableRef),
                          .s("backgroundColor = "),
                          .c("UIColor", color(for: fill.color)))
            case let shadow as MSStyleShadow:
                scope.add(expression: .v(variableRef),
                          .s("layer.shadowColor = "),
                          .c("UIColor", color(for: shadow.color)), .s(".cgColor"))
                scope.add(expression: .v(variableRef),
                          .s("layer.shadowOffset = "),
                          .c("CGSize", "CGSize(width: \(shadow.offsetX), height: \(shadow.offsetY))"))

                // I'm not sure how alpha is expressed.
                scope.add(expression: .v(variableRef), .s("layer.shadowOpacity = 1"))
            case let border as MSStyleBorder:
                assert(border.fillType == 0, "Only border fill is supported")
                scope.add(expression: .v(variableRef),
                          .s("layer.borderColor = "),
                          .c("UIColor", color(for: border.color)), .s(".cgColor"))
                scope.add(expression: .v(variableRef),
                          .s("layer.borderWidth = "), .s("\(border.thickness)"))
            default:
                print("Skipping: \(attribute)")
            }
        }
    }

    func configureLabel(_ variableRef: VariableRef, in scope: Scope, attributedString: NSAttributedString) {
        scope.add(expression: .v(variableRef),
                  .s("text = "),
                  .c("String", attributedString.string))

//        scope.add(expression: .v(variableRef),
//                  .s("textColor = "),
//                  .c("UIColor", color))
//        scope.add(expression: .v(variableRef),
//                  .s("font = "),
//                  .c("UIFont", font))
    }

    func configureChildren(_ variableRef: VariableRef?, in scope: Scope, layer: MSShapeLayer) throws {
        guard let layer = layer as? LayerContainer else { return }
        // If this view has a child that is at the bottom of the Z index and represents
        // a square, remove that layer and apply the style to this view.
        if let variableRef = variableRef,
            let lowest = layer.lowestLayer as? MSShapeGroup,
            let rectShape = lowest.layers.first as? PathContainer,
            rectShape.isASquare {

            layer.removeLowestLayer()
            configureStyle(variableRef, in: scope, style: lowest.style)
            if let first = rectShape.path.points.first, first.cornerRadius != 0 {
                scope.add(expression: .v(variableRef),
                          .s("layer.cornerRadius = "), .s("\(first.cornerRadius)"))
            }
        }
        for childVariable in try layer.visibleLayers.flatMap({ try build(layer: $0, in: scope) }) {
            if let variableRef = variableRef {
                scope.add(BasicExpression(.v(variableRef), .s("addSubview"), .p(childVariable.value)))
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

    func color(for color: MSColor) -> String {
        var value = color.value
        if let range = value.range(of: "rgba(") {
            value.removeSubrange(range)
            value.removeLast()
            let components = value
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 4 else { fatalError("Invalid rgba definition: \(color.value)") }
            let (red, green, blue, alpha) = (components[0], components[1], components[2], components[3])
            return "UIColor(red: CGFloat(\(red)) / 255.0, green: CGFloat(\(green)) / 255.0, blue: CGFloat(\(blue)) / 255.0, alpha: CGFloat(\(alpha)) / 255.0)"
        }
        return "UIColor(unknownFormat: \"\(color.value)\")"
    }
}
