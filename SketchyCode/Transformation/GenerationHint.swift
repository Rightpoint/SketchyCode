//
//  GenerationHint.swift
//  SketchyCode
//
//  Created by Brian King on 10/13/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct GenerationHintParseError: Error {
    let input: String
    let objectID: String
}

struct GenerationHint {
    let className: String?
    let variableName: String?
    let stateName: String?

    static func makeHint(input: String, objectID: String) throws -> GenerationHint {
        guard let openIndex = input.index(of: "$"), input[input.index(after: openIndex)] == "(", let closeIndex = input.index(of: ")") else {
            return GenerationHint(className: nil, variableName: nil, stateName: nil)
        }
        var className: String?
        var variableName: String?
        var stateName: String?

        for var part in input.substring(with: input.index(openIndex, offsetBy: 2)..<closeIndex).split(separator: ",") {
            var first = part.removeFirst()
            while first == " " { first = part.removeFirst() }
            while part.last == " " { part.removeLast() }
            switch first {
            case "@": className = String(part)
            case "^": variableName = String(part)
            case "%": stateName = String(part)
            default: throw GenerationHintParseError(input: input, objectID: objectID)
            }
        }
        return GenerationHint(className: className, variableName: variableName, stateName: stateName)
    }
}
