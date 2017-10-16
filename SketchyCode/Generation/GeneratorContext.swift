//
//  GeneratorContext.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct GeneratorOptions {
    var generatePropertyClosures: Bool = true
}

class GeneratorContext {
    let writer: Writer = Writer()
    var namingStrategy: NamingStrategy
    var options: GeneratorOptions

    init(namingStrategy: NamingStrategy, options: GeneratorOptions) {
        self.namingStrategy = namingStrategy
        self.options = options
    }
}
