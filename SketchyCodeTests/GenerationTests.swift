//
//  GenerationTests.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import XCTest
@testable import SketchyCode

// This file tests specific code generation behaviors. It does not aim to generate
// valid swift code.
class GenerationTests: XCTestCase {
    let global = GlobalScope()

    override func setUp() {
        super.setUp()
        namingStrategy = CounterNamingStrategy()
    }

    func makeSimpleDeclarations() -> (view: ClassDeclaration, label: VariableDeclaration, heading: VariableDeclaration) {
        let view = global.makeVariable(ofType: "UIView")
        let customView = global.makeClass(ofType: "MyView", inheriting: "UIView", for: view)
        let label = customView.makeVariable(ofType: "UILabel")
        let heading = customView.makeVariable(ofType: "UILabel")
        return (view: customView, label: label, heading: heading)
    }

    func generate() throws -> String {
        let writer = Writer()
        try global.generate(writer: writer)
        print(writer.content)
        return writer.content
    }

    func testImplicitSelfBehavior() throws {
        let (view, label, _) = makeSimpleDeclarations()
        view.add(contentsOf: [
            SimpleExpression(.o(view.selfRef), .s("addSubview"), .p(label.value)),
            SimpleExpression(.s("print"), .p(view.selfRef))
            ])
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel
            let label1: UILabel
            addSubview(label0)
            print(self)
        }
        let view2: MyView

        """
        XCTAssert(try generate() == expected)
    }


    func testContainedVariableLookup() throws {
        let (view, label, heading) = makeSimpleDeclarations()

        let configuration: [Generator] = [
            SimpleExpression(.o(view.selfRef), .s("addSubview"), .p(heading.value)),
            SimpleExpression(.o(view.selfRef), .s("addSubview"), .p(label.value)),
            SimpleExpression(.o(heading.value), .s("text = \"testing\"")),
            SimpleExpression(.o(label.value), .s("text = \"label\""))
        ]
        // Add the same configuration to two different scopes and ensure the variable lookup is correct.
        view.add(contentsOf: configuration)
        global.add(contentsOf: configuration)
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel
            let label1: UILabel
            addSubview(label1)
            addSubview(label0)
            label1.text = "testing"
            label0.text = "label"
        }
        let view2: MyView
        view2.addSubview(view2.label1)
        view2.addSubview(view2.label0)
        view2.label1.text = "testing"
        view2.label0.text = "label"

        """
        XCTAssert(try generate() == expected)
    }
}

