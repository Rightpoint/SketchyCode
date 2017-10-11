//
//  GlobalScope.swift
//  SketchyCode
//
//  Created by Brian King on 10/10/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class GlobalScope: Scope {
    override func generate(in scope: Scope, context: GeneratorContext) throws {
        context.writer.append(line: "// Automatically generated. Do Not Edit!")
        try children.forEach {
            if $0 is ClassDeclaration {
                try $0.generate(in: self, context: context)
            }
        }
        try children.forEach {
            if !($0 is ClassDeclaration) {
                try $0.generate(in: self, context: context)
            }
        }
    }
}
