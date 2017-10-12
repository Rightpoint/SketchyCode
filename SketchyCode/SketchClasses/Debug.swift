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
        var description = super.description
        description.removeLast()
        if let styled = self as? Styled {
            let info = styled.style.enabledAttributes.map { $0.description }.joined(separator: ", ")
            description.append(" attributes=[")
            description.append(info)
            description.append("]")
        }

        if let pathContainer = self as? PathContainer {
            description.append(" pathPointCount=\(pathContainer.path.points.count)")
        }
        if let layerContainer = self as? LayerContainer {
            description.append(" layers=[\(layerContainer.layers.map { $0.description })]")
        }

        description.append(">")
        return description
    }
}
