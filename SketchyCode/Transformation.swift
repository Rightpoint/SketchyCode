//
//  Transformation.swift
//  SketchyCode
//
//  Created by Brian King on 9/14/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

// Remove all hidden layers
// Expand Shared Styles in Document
// Generation Context (Function, Subclass, NavigationItem, Asset)
// Extract [Labels, Images, Views]
// Build / Layout / Style
// Extract Constraints
// Collapse Containers

import AppKit

struct GenerationContext {
    let document: MSDocumentData
}

struct ClipDecoration {
    let path: MSShapePath
}

struct TextDecoration {
    let string: NSAttributedString
    let style: MSTextStyle
}

struct FillDecoration {
    let style: MSStyleFill
}

struct ShadowDecoration {
    let style: MSStyleShadow
}

enum GenerationPhase {
    case declaration
    case properties
    case construction
    case layout
}

protocol Decoration {
    func apply(phase: GenerationPhase, from context: GenerationContext)
}

protocol LayerStrategy {
    func transform(layer: MSShapeLayer) -> [Layer]
}

protocol ConfigurationStrategy {
    func transform(layer: MSShapeLayer) -> [Decoration]
}


struct Layer {
    let name: String
    var frame: CGRect
    var rotation: CGAffineTransform // flipped? + rotation
    var decorations: [Decoration]
    var children: [Layer]
}
