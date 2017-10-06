//
//  Utils.swift
//  SketchyCode
//
//  Created by Brian King on 10/6/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

extension String {

    public func objcnessRemoved() -> String {
        var mutating = self
        let indicies = characters.indices
        let firstIndex = indicies.startIndex
        let lowerIndex = indicies.index(after: indicies.index(after: firstIndex))
        let toLower = characters[lowerIndex]
        mutating.replaceSubrange(firstIndex...lowerIndex, with: String(toLower).lowercased())
        return mutating
    }

    public var variabled: String {
        var first = true
        let parts = components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.lengthOfBytes(using: .utf8) > 0 }

        return parts.map({
            var string = $0
            let indicies = string.characters.indices
            let firstIndex = indicies.startIndex
            let toChange = String(string.characters[firstIndex])
            string.replaceSubrange(firstIndex...firstIndex,
                                   with: first ? toChange.lowercased() : toChange.uppercased())
            first = false
            return string
        }).joined(separator: "")
    }
}
