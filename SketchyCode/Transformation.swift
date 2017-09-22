//
//  Transformation.swift
//  SketchyCode
//
//  Created by Brian King on 9/14/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

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

struct ClassContext {

}

enum GenerationPhase {
    case declaration
    case properties
    case construction
    case layout
}


