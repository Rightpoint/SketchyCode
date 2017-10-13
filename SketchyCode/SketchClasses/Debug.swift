//
//  Debug.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import AppKit

extension MSShapeLayer {
    public override var description: String {
        let writer = Writer()
        dump(to: writer)
        return writer.content
    }

    func dump(to writer: Writer) {
        let styled = self as? Styled
        let layerContainer = self as? LayerContainer
        let addNewline = (
            !(styled?.style.enabledAttributes.isEmpty ?? true) &&
            !(layerContainer?.layers.isEmpty ?? true))

        let leading = addNewline ? "" : " "
        var description = "<\(self.className)"
        description.range(of: "SketchyCode.").flatMap( { description.removeSubrange($0) })
        writer.append(line: description, addNewline: addNewline)
        writer.level += 1

        if let styled = styled {
            let info = styled.style.enabledAttributes.map { $0.description }.joined(separator: ", ")
            writer.append(line: "\(leading)attributes=[\(info)]", addNewline: addNewline)
        }

        if let pathContainer = self as? PathContainer {
            writer.append(line: "\(leading)pathPointCount=\(pathContainer.path.points.count)", addNewline: addNewline)
        }
        if let layerContainer = layerContainer {
            writer.append(line: "\(leading)layers=[", addNewline: layerContainer.layers.count > 1)
            writer.level += 1
            for layer in layerContainer.layers {
                layer.dump(to: writer)
            }
            writer.level -= 1
            writer.append(line: "]")
        }
        writer.level -= 1
        writer.append(line: ">")
    }
}
extension MSColor {
    var summary: String {
        return "<Color \(value)>"
    }
}

extension NSFont {
    var summary: String {
        return "<Font \(fontName)>"
    }
}
extension Enableable {
    func makeSummary(_ className: String, _ enabledString: String) -> String {
        if !isEnabled {
            return "<\(className) disabled>"
        } else {
            return "<\(className) \(enabledString)>"
        }
    }
}
extension MSStyle {
    public override var description: String {
        return "<Style \(enabledAttributes.map({ $0.description }))>"
    }
}
extension MSTextStyle {
    public override var description: String {

        return "<TextStyle "
    }
}
extension MSStyleShadow {
    public override var description: String {
        return makeSummary("Shadow", "offset=\(offsetX),\(offsetY) radius=\(blurRadius) spread=\(spread) color=\(color.summary)")
    }
}
extension MSStyleReflection {
    public override var description: String {
        return makeSummary("Reflection", "distance=\(distance) strength=\(strength)")
    }
}
extension MSStyleFill {
    public override var description: String {
        return makeSummary("Fill", "color=\(color.summary) fillType=\(fillType) gradient=\(gradient) image=\(image?.description ?? "None")")
    }
}
extension MSStyleBorderOptions {
    public override var description: String {
        return makeSummary("BorderOpt", "lineCapStyle=\(lineCapStyle) dashPattern=\(dashPattern) lineJoinStyle=\(lineJoinStyle)")
    }
}
extension MSStyleInnerShadow {
    public override var description: String {
        return makeSummary("InnerShadow", "TBD")
    }
}
extension MSGraphicsContextSettings {
    public override var description: String {
        return "<GraphicsContext blendMode=\(blendMode) opacity=\(opacity)>"
    }
}
extension MSStyleBorder {
    public override var description: String {
        return makeSummary("Border", "TBD")
    }
}
extension MSStyleColorControls {
    public override var description: String {
        return makeSummary("ColorControl", "contrast=\(contrast) saturation=\(saturation) hue=\(hue) brightness=\(brightness)")
    }
}
extension MSStyleBlur {
    public override var description: String {
        return makeSummary("Blur", "center=\(center.x),\(center.y) radius=\(radius) type=\(type) motionAngle=\(motionAngle)")
    }
}

extension MSGradient {
    public override var description: String {
        return makeSummary("Gradient", "TBD")
    }
}

