//
//  UtilsTests.swift
//  SketchyCodeTests
//
//  Created by Brian King on 10/13/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

import XCTest
@testable import SketchyCode
import Marshal

class UtilsTests: XCTestCase {
    func testMakeGenerationHint() throws {
        let generation = try GenerationHint.makeHint(input: "blah blah $(@className,   ^variable, %state   ) blah", objectID: "X")
        XCTAssertEqual("className", try generation.className.unwrapped())
        XCTAssertEqual("variable", try generation.variableName.unwrapped())
        XCTAssertEqual("state", try generation.stateName.unwrapped())
    }

    func testSplitBySize() throws {
        var split: [String] = "AABBCC".split(by: 2)
        XCTAssertEqual(try split.popLast().unwrapped(), "CC")
        XCTAssertEqual(try split.popLast().unwrapped(), "BB")
        XCTAssertEqual(try split.popLast().unwrapped(), "AA")
    }
}

