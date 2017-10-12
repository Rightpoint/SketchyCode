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

    func generate() throws -> String {
        let context = GeneratorContext(
            namingStrategy: CounterNamingStrategy(),
            options: GeneratorOptions())

        try global.generate(context: context)
        print(context.writer.content)
        return context.writer.content
    }

    func testImplicitSelfBehavior() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        let subview = global.makeClass(ofType: "MyView", for: view)
        let label = subview.makeVariable(ofType: "UILabel", initializedWith: BasicExpression(.s("UILabel()")))

        global.add(contentsOf: [
            BasicExpression(.v(view.value), .s("addSubview"), .p(label.value)),
            BasicExpression(.s("print"), .p(view.value))])


        global.moveExpressions(for: view, to: subview)

        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = UILabel()
            addSubview(label0)
            print(self)
        }
        let view2: MyView = MyView()

        """
        XCTAssert(try generate() == expected)
    }

    func testInitialization() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        let subview = global.makeClass(ofType: "MyView", for: view)
        _ = subview.makeVariable(ofType: "UILabel", initializedWith: BasicExpression(.s("UILabel()")))

        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = UILabel()
        }
        let view1: MyView = MyView()

        """
        XCTAssert(try generate() == expected)
    }

    // Ensure that a variable added to an initialization closure does have
    // access to the global scope
    func testInitializationClosureAccessContaining() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        let subview = global.makeClass(ofType: "MyView", for: view)
        let label = subview.makeVariable(ofType: "UILabel", initializedWith: BasicExpression(.s("UILabel()")))
        let globalString = global.makeVariable(ofType: TypeRef(name: "String"), initializedWith: BasicExpression(.s("\"\"")))

        let block = global.makeBlock(children: [
            BasicExpression(.v(label.value), .s("text = "), .debug(.v(globalString.value)))
        ])
        label.initialization = AssignmentExpression(to: label.value, expression: block)

        // Horrible code generation!
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = {
                view1.label0.text = ring2
            }()
        }
        let view1: MyView = MyView()
        let ring2: String = ""

        """
        XCTAssert(try generate() == expected)
    }

    func testExpressionTransformations() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        // FIXME: Generate first without making a class
        let subview = global.makeClass(ofType: "MyView", for: view)
        let label = subview.makeVariable(ofType: "UILabel", initializedWith: BasicExpression(.s("UILabel()")))
        let heading = subview.makeVariable(ofType: "UILabel", initializedWith: BasicExpression(.s("UILabel()")))

        global.add(contentsOf: [
            BasicExpression(.v(view.value), .s("addSubview"), .p(heading.value)),
            BasicExpression(.v(view.value), .s("addSubview"), .p(label.value)),
            BasicExpression(.v(heading.value), .s("text = \"testing\"")),
            BasicExpression(.v(label.value), .s("text = \"label\""))
            ])
        XCTAssert(try generate() ==
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = UILabel()
            let label1: UILabel = UILabel()
        }
        let view2: MyView = MyView()
        view2.addSubview(view2.label1)
        view2.addSubview(view2.label0)
        view2.label1.text = "testing"
        view2.label0.text = "label"

        """)

        // Move the expressions into the subview, and remove the global variable
        // reference.
        global.moveExpressions(for: view, to: subview)
        try global.remove(view)
        // FIXME: subview.moveExpressionsToInitializer()

        XCTAssert(try generate() ==
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = UILabel()
            let label1: UILabel = UILabel()
            addSubview(label1)
            addSubview(label0)
            label1.text = "testing"
            label0.text = "label"
        }

        """)

        // Move all isolated expressions into property closures
        subview.moveExpressionsToPropertyClosures()

        XCTAssert(try generate() ==
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label0: UILabel = {
                let label1: UILabel = UILabel()
                label1.text = "label"
                return label1
            }()
            let label2: UILabel = {
                let label3: UILabel = UILabel()
                label3.text = "testing"
                return label3
            }()
            addSubview(label2)
            addSubview(label0)
        }

        """)
    }

    func testNestedVariableLookup() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        let subview = global.makeClass(ofType: "MyView", for: view)
        let bg = subview.makeVariable(ofType: TypeRef(name: "UIView"), initializedWith: BasicExpression(.s("BKBackgroundView()")))

        let bgView = global.makeClass(ofType: TypeRef(name: "BKBackgroundView"), for: bg)
        let image = bgView.makeVariable(ofType: TypeRef(name: "UIImageView"), initializedWith: BasicExpression(.s("BKBackgroundView()")))

        global.add(BasicExpression(.v(image.value), .s("image = UIImage(named: \"test\")")))
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let backgroundView0: BKBackgroundView = BKBackgroundView()
        }
        class BKBackgroundView: UIView {
            let imageView1: UIImageView = BKBackgroundView()
        }
        let view2: MyView = MyView()
        view2.backgroundView0.imageView1.image = UIImage(named: "test")

        """
        XCTAssert(try generate() == expected)
    }
}
