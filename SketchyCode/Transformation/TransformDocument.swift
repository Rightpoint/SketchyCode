//
//  Transformation.swift
//  SketchyCode
//
//  Created by Brian King on 10/12/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

class TransformDocument {
    let document: MSDocumentData
    var builder: Builder
    let scope: GlobalScope = GlobalScope()
    init(document: MSDocumentData, with builder: Builder) {
        self.builder = builder
        self.document = document
    }

    func transform(layer: MSShapeLayer) throws {
        _ = try builder.build(layer: layer, in: scope)
    }

    func generate() throws -> String {
        let context = GeneratorContext(
            namingStrategy: CounterNamingStrategy(),
            options: GeneratorOptions())

        try scope.generate(context: context)
        return context.writer.content
    }
}
