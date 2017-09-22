
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
    
    func testPagesLoad() throws {
        let helper = try InputSketchHelper()
        XCTAssert(helper.document.pages.count == 11)
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

    func testShapeLoad() throws {
        let helper = try InputSketchHelper()
        let shape = try helper.shape.unwrapped()
        let closedLine = try shape.layer(withName: "Closed Line").unwrapped(as: MSShapeGroup.self)
        let pencil = try shape.layer(withName: "Pencil").unwrapped(as: MSShapeGroup.self)
        let vector = try shape.layer(withName: "Vector").unwrapped(as: MSShapeGroup.self)
        let triangle = try shape.layer(withName: "Triangle").unwrapped(as: MSShapeGroup.self)
        let polygon = try shape.layer(withName: "Polygon").unwrapped(as: MSShapeGroup.self)
        let star = try shape.layer(withName: "Star").unwrapped(as: MSShapeGroup.self)
        let rounded = try shape.layer(withName: "Rounded").unwrapped(as: MSShapeGroup.self)
        let arrow = try shape.layer(withName: "Arrow").unwrapped(as: MSShapeGroup.self)
        let line = try shape.layer(withName: "Line").unwrapped(as: MSShapeGroup.self)
        let oval = try shape.layer(withName: "Oval").unwrapped(as: MSShapeGroup.self)
        let rect = try shape.layer(withName: "Rectangle").unwrapped(as: MSShapeGroup.self)
        let shapeGroups = [closedLine, pencil, vector, triangle, polygon, star, rounded, arrow, line, oval, rect]
        for shape in shapeGroups {
            XCTAssert(shape.layers.count == 1)
        }
        let paths = try shapeGroups.flatMap { try $0.layers.first.unwrapped(as: PathContainer.self).path }
        for path in paths {
            XCTAssert(path.points.count >= 2)
        }
    }

    func testBezierPathConversion() throws {
        
    }
}
