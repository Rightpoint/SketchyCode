//
//  GenerationTests.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import XCTest
@testable import SketchyCode

class GenerationTests: XCTestCase {
    func testCommand() throws {

        let global = GlobalDeclarationContext()

        // Types should be un-named until generation.
        let customView = global.makeClass(ofType: "MyView", inheriting: "UIView")

        let label = customView.makeVariable(ofType: "UILabel")
        let heading = customView.makeVariable(ofType: "UILabel")

        customView.add(contentsOf: [
            AssignmentExpression(to: label.value, .string("UILabel()")),
            AssignmentExpression(to: heading.value, .string("UILabel()")),
            SimpleExpression(.object(label.value), .string("text = \"label\"")),
            SimpleExpression(.object(heading.value), .string("text = \"heading\"")),
            SimpleExpression(.object(customView.representingSelf), .string("addSubview"), .p(heading.value)),
            SimpleExpression(.object(customView.representingSelf), .string("addSubview"), .p(label.value))
        ])

        // TODO: Implement Layout Strategy passes that make the above compile.

        let writer = Writer()
        try global.generate(writer: writer)
        print(writer.content)
    }
}

