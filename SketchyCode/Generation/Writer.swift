//
//  Writer.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class Writer {
    var content: String = ""
    var level: Int = 0
    var indentation: String = "    "

    func indent(work: () throws -> Void) throws {
        level += 1
        try work()
        level -= 1
    }

    func append(line: String, addNewline: Bool = true) {
        var indented = ""
        for _ in 0..<level {
            indented.append(indentation)
        }
        indented.append(line)
        if addNewline {
            indented.append("\n")
        }
        content.append(indented)
    }
}
