//
//  GenerationTests.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import XCTest
@testable import SketchyCode


protocol Declaration {
    var provides: Object { get }
}

class GenerationTests: XCTestCase {
    func testCommand() throws {
        let heading = Object(ofType: "UILabel")
        let label = Object(ofType: "UILabel")
        let color = Object(ofType: "UIColor")

//        let global = GlobalDeclarationContext()
//        let view = global.makeObject(ofType: "UIView")
//        let cls = global.makeClass(representing: view)
//
//        let label = cls.makeObject(ofType: "UILabel")
//        let heading = cls.makeObject(ofType: "UILabel")
//        cls.addExpressions([
//            CommandGenerator(provides: view, .string("UIView()")),
//            CommandGenerator(.object(view), .string("backgroundColor = "), .object(color))
//        ])

//        let property = VariableDeclaration(
//            object: view,
//            generators: [
//                CommandGenerator(provides: view, .string("UIView()")),
//                CommandGenerator(.object(view), .string("backgroundColor = "), .object(color))
//            ])
//        global.addChild(property)
//        global.addReference(DeclarationReference(value: "view", object: view))
//
//        let writer = Writer()
//        try global.generate(writer: writer)
//        print(writer.content)

//        graph.addContext(.view) { selfVariable in
//            selfVariable.format("\(selfVariable).backgroundColor = \(colorVariable)"
    }
}

