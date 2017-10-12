//
//  TransformationTests.swift
//  SketchyCodeTests
//
//  Created by Brian King on 10/12/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

import XCTest
@testable import SketchyCode

class TransformationLayoutTests: XCTestCase {
    func testGroup() throws {
        let helper = try InputSketchHelper()
        let transformDocument = TransformDocument(
            document: helper.document,
            with: SwiftUIKitBuilder())

        guard let page = helper.layout, let group = page.layer(withName: "Group") else {
            throw GenericTestFailure(description: "Unable to find the layout page")
        }
        try transformDocument.transform(layer: group)
        XCTAssert(try transformDocument.generate() ==
        """
        // Automatically generated. Do Not Edit!
        let view0: UIView = UIView()
        view0.frame = CGRect(x: -396.0, y: -281.0, width: 188.0, height: 623.0)
        let view1: UIView = UIView()
        view1.frame = CGRect(x: 0.0, y: 0.0, width: 188.0, height: 623.0)
        let view2: UIView = UIView()
        view2.frame = CGRect(x: 24.0, y: 37.0, width: 55.0, height: 154.0)
        let view3: UIView = UIView()
        view3.frame = CGRect(x: 24.0, y: 447.0, width: 55.0, height: 153.0)
        let view4: UIView = UIView()
        view4.frame = CGRect(x: 111.0, y: 201.0, width: 56.0, height: 234.0)
        view0.addSubview(view1)
        view0.addSubview(view2)
        view0.addSubview(view3)
        view0.addSubview(view4)

        """)
    }
}
