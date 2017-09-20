
//
//  SketchyCodeTests.swift
//  SketchyCodeTests
//
//  Created by Brian King on 9/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import XCTest
@testable import SketchyCode
import Marshal

class SketchyCodeTests: XCTestCase {
    
    func testLoad() throws {
        let document: MSDocumentData
        do {
            document = try MSDocumentData(object: InputSketchHelper.JSON)
        } catch {
            print(error)
            throw error
        }
        XCTAssert(document.pages.count == 11)

        let helper = InputSketchHelper(document: document)
        XCTAssertNotNil(helper.shape)
        XCTAssertNotNil(helper.layout)
        XCTAssertNotNil(helper.fill)
        XCTAssertNotNil(helper.border)
        XCTAssertNotNil(helper.shadow)
        XCTAssertNotNil(helper.combine)
        XCTAssertNotNil(helper.transform)
        XCTAssertNotNil(helper.text)
        XCTAssertNotNil(helper.images)
        XCTAssertNotNil(helper.artboard)
        XCTAssertNotNil(helper.symbols)
    }
    
}
