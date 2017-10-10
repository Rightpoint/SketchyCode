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
        let labelType = TypeRef(name: "UILabel")
        let viewType = TypeRef(name: "UIView")
        let view = global.makeVariable(ofType: viewType)
        let customView = global.makeClass(ofType: TypeRef(name: "MyView"), for: view)
        let label = customView.makeVariable(ofType: labelType)
        let heading = customView.makeVariable(ofType: labelType)
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
            SimpleExpression(.v(view.selfRef), .s("addSubview"), .p(label.value)),
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

    // Ensure that a variable added to an initialization closure does have
    // access to the global scope
    func testInitializationClosureAccessContaining() throws {
        let (_, label, _) = makeSimpleDeclarations()
        let globalString = global.makeVariable(ofType: TypeRef(name: "String"))
        label.initialization.add(contentsOf: [
            SimpleExpression(.v(label.value), .s("text = "), .debug(.v(globalString.value)))
            ])
        // Horrible code generation!
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabelview1.label0.text = ring2
            let label3: UILabel
        }
        let view1: MyView
        let ring2: String

        """
        XCTAssert(try generate() == expected)
    }

    // Ensure that a variable added to an initialization closure does not have
    // access to self
    func testInitializationClosureNoSelf() throws {
        let (_, label, _) = makeSimpleDeclarations()
        label.initialization.add(contentsOf: [
            SimpleExpression(.v(label.value), .s("text = \"label\""))
            ])
        // Horrible code generation! This should throw, but the class implicit
        // self is global so the variable is found.
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabelview1.label0.text = "label"
            let label2: UILabel
        }
        let view1: MyView

        """
        XCTAssert(try generate() == expected)

//        XCTAssertThrowsError(try generate())
    }

    func testContainedVariableLookup() throws {
        let (view, label, heading) = makeSimpleDeclarations()

        let configuration: [Generator] = [
            SimpleExpression(.v(view.selfRef), .s("addSubview"), .p(heading.value)),
            SimpleExpression(.v(view.selfRef), .s("addSubview"), .p(label.value)),
            SimpleExpression(.v(heading.value), .s("text = \"testing\"")),
            SimpleExpression(.v(label.value), .s("text = \"label\""))
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

    func testNestedVariableLookup() throws {
        let (view, _, _) = makeSimpleDeclarations()
        let bg = view.makeVariable(ofType: TypeRef(name: "UIView"))

        let bgView = global.makeClass(ofType: TypeRef(name: "BKBackgroundView"), for: bg)
        let image = bgView.makeVariable(ofType: TypeRef(name: "UIImageView"))

        global.add(SimpleExpression(.v(image.value), .s("image = UIImage(named: \"test\")")))
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel
            let label1: UILabel
            let backgroundView2: BKBackgroundView
        }
        class BKBackgroundView: UIView {
            let imageView3: UIImageView
        }
        let view4: MyView
        view4.backgroundView2.imageView3.image = UIImage(named: "test")

        """
        XCTAssert(try generate() == expected)
    }
}
