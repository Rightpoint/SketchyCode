//
//  BlockExpression.swift
//  SketchyCode
//
//  Created by Brian King on 10/9/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

final class BlockExpression: Scope {
    var children: [Generator]

    init(children: [Generator] = []) {
        self.children = children
    }

    var hasContent: Bool {
        return children.count > 0
    }
}

extension BlockExpression: Generator {
    func generate(in scope: Scope, context: GeneratorContext) throws {
        try context.writer.block(appending: "()") {
            try children.forEach { try $0.generate(in: scope, context: context) }
        }
    }
}


