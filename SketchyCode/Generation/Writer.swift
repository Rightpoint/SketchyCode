//
//  Writer.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// Writer is responsible for managing the structure of the generated output.
final class Writer {
    static var indentation: String = "    "
    var content: String = ""
    var level: Int = 0

    func indent(work: () throws -> Void) throws {
        level += 1
        try work()
        level -= 1
    }

    func block(appending: String = "", work: () throws -> Void) throws {
        append(line: "{")
        try indent(work: work)
        append(line: "}\(appending)")
    }

    var addIndentation: Bool {
        return content.count == 0 || content.last == "\n"
    }

    func append(line: String, addNewline: Bool = true) {
        var value = ""
        if addIndentation {
            for _ in 0..<level {
                value.append(Writer.indentation)
            }
        }
        value.append(line)
        if addNewline {
            value.append("\n")
        }
        content.append(value)
    }
}
