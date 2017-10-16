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
            namingStrategy: SwiftUIKitNamingStrategy(),
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
            let label: UILabel = UILabel()
            addSubview(label)
            print(self)
        }
        let myView: MyView = MyView()

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
            let label: UILabel = UILabel()
        }
        let myView: MyView = MyView()

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
            let label: UILabel = {
                myView.label.text = string
            }()
        }
        let myView: MyView = MyView()
        let string: String = ""

        """
        XCTAssert(try generate() == expected)
    }

    func testExpressionTransformations() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
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
            let label: UILabel = UILabel()
            let label2: UILabel = UILabel()
        }
        let myView: MyView = MyView()
        myView.addSubview(myView.label)
        myView.addSubview(myView.label2)
        myView.label.text = "testing"
        myView.label2.text = "label"

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
            let label: UILabel = UILabel()
            let label2: UILabel = UILabel()
            addSubview(label2)
            addSubview(label)
            label2.text = "testing"
            label.text = "label"
        }

        """)

        // Move all isolated expressions into property closures
        subview.moveExpressionsToPropertyClosures()

        XCTAssert(try generate() ==
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let label: UILabel = {
                let label: UILabel = UILabel()
                label.text = "label"
                return label
            }()
            let label2: UILabel = {
                let label: UILabel = UILabel()
                label.text = "testing"
                return label
            }()
            addSubview(label2)
            addSubview(label)
        }

        """)

    }

    func testNestedVariableLookup() throws {
        let view = global.makeVariable(ofType: "UIView", initializedWith: BasicExpression(.s("MyView()")))
        let subview = global.makeClass(ofType: "MyView", for: view)
        let bg = subview.makeVariable(ofType: TypeRef(name: "UIView"), initializedWith: BasicExpression(.s("BackgroundView()")))

        let bgView = global.makeClass(ofType: TypeRef(name: "BackgroundView"), for: bg)
        let image = bgView.makeVariable(ofType: TypeRef(name: "UIImageView"), initializedWith: BasicExpression(.s("BackgroundView()")))

        global.add(BasicExpression(.v(image.value), .s("image = UIImage(named: \"test\")")))
        let expected =
        """
        // Automatically generated. Do Not Edit!
        class MyView: UIView {
            let backgroundView: BackgroundView = BackgroundView()
        }
        class BackgroundView: UIView {
            let imageView: UIImageView = BackgroundView()
        }
        let myView: MyView = MyView()
        myView.backgroundView.imageView.image = UIImage(named: "test")

        """
        XCTAssert(try generate() == expected)
    }
}
