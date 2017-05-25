//
//  String.swift
//  SketchyCode
//
//  Created by Brian King on 5/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

extension String {
    
    func objcnessRemoved() -> String {
        var mutating = self
        let indicies = characters.indices
        let firstIndex = indicies.startIndex
        let lowerIndex = indicies.index(after: indicies.index(after: firstIndex))
        let toLower = characters[lowerIndex]
        mutating.replaceSubrange(firstIndex...lowerIndex, with: String(toLower).lowercased())
        return mutating
    }
}
extension NSString {
    var objcnessShapeAndLayerRemoved: String {
        let str = (self as String).objcnessRemoved()
            .replacingOccurrences(of: "Shape", with: "", options: [.backwards], range: nil)
            .replacingOccurrences(of: "Layer", with: "", options: [.backwards], range: nil)
        return str
    }
    
}

