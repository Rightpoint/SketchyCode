//
//  ClosureDeclaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class ClosureDeclaration: Scope {

    init(generators: [Generator]) {
        super.init()
        children = generators
    }

    var hasContent: Bool {
        return children.count > 0
    }

    override func generate(in context: Scope, writer: Writer) throws {
        if children.count == 1 {
            try children[0].generate(in: self, writer: writer)
        } else {
            try writer.block(appending: "()") {
                try children.forEach { try $0.generate(in: self, writer: writer) }
            }
        }
    }
}
