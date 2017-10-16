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

    public func split(by size: Int) -> [String] {
        return stride(from: 0, to: characters.count, by: size)
            .reversed()
            .map { i -> String in
                let endIndex = self.index(self.endIndex, offsetBy: -i)
                let startIndex = self.index(endIndex, offsetBy: -size)
                return self[startIndex..<endIndex]
        }
    }
}
