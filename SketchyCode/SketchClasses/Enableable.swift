//
//  Enableable.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol Enableable: NSObjectProtocol {
    var isEnabled: Bool { get }
}

extension MSLayoutGrid: Enableable {}
extension MSSimpleGrid: Enableable {}
extension MSStyleBlur: Enableable {}
extension MSStyleBorder: Enableable {}
extension MSStyleBorderOptions: Enableable {}
extension MSStyleColorControls: Enableable {}
extension MSStyleFill: Enableable {}
extension MSStyleInnerShadow: Enableable {}
extension MSStyleReflection: Enableable {}
extension MSStyleShadow: Enableable {}

protocol EnableableContainer {
    var enablableAttributes: [Enableable] { get }
}

extension EnableableContainer {
    var enabledAttributes: [NSObjectProtocol] {
        return enablableAttributes.filter({ $0.isEnabled })
    }
}

extension MSStyle: EnableableContainer {
    var enablableAttributes: [Enableable] {
        var result: [Enableable] = []
        result.append(blur)
        borders.forEach({ result.append($0) })
        shadows.forEach({ result.append($0) })
        fills.forEach({ result.append($0) })
        innerShadows.forEach({ result.append($0) })
        borders.forEach({ result.append($0) })
        result.append(reflection)
        result.append(blur)
        result.append(colorControls)
        result.append(borderOptions)
        return result
    }
}
