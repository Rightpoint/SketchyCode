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
        let generated = try transformDocument.generate()
        print(generated)
        XCTAssert(generated ==
        """
        // Automatically generated. Do Not Edit!
        let view: UIView = UIView()
        view.frame = CGRect(x: -396.0, y: -281.0, width: 188.0, height: 623.0)
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        let view2: UIView = UIView()
        view2.frame = CGRect(x: 0.0, y: 0.0, width: 188.0, height: 623.0)
        view2.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        view2.layer.borderColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0).cgColor
        view2.layer.borderWidth = 1.0
        view2.backgroundColor = UIColor(red: 0xD8 / 255.0, green: 0xD8 / 255.0, blue: 0xD8 / 255.0)
        let view3: UIView = UIView()
        view3.frame = CGRect(x: 24.0, y: 37.0, width: 55.0, height: 154.0)
        view3.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleHeight]
        view3.layer.borderColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0).cgColor
        view3.layer.borderWidth = 1.0
        view3.backgroundColor = UIColor(red: 0xD8 / 255.0, green: 0xD8 / 255.0, blue: 0xD8 / 255.0)
        let view4: UIView = UIView()
        view4.frame = CGRect(x: 24.0, y: 447.0, width: 55.0, height: 153.0)
        view4.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight, .flexibleBottomMargin]
        view4.layer.borderColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0).cgColor
        view4.layer.borderWidth = 1.0
        view4.backgroundColor = UIColor(red: 0xD8 / 255.0, green: 0xD8 / 255.0, blue: 0xD8 / 255.0)
        let view5: UIView = UIView()
        view5.frame = CGRect(x: 111.0, y: 202.0, width: 56.0, height: 234.0)
        view5.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        view5.layer.borderColor = UIColor(red: 0x97 / 255.0, green: 0x97 / 255.0, blue: 0x97 / 255.0).cgColor
        view5.layer.borderWidth = 1.0
        view5.backgroundColor = UIColor(red: 0xD8 / 255.0, green: 0xD8 / 255.0, blue: 0xD8 / 255.0)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        view.addSubview(view5)

        """)
    }
}

class TransformationAppTests: XCTestCase {
    func testAppProfile() throws {
        let helper = try InputSketchHelper()
        let transformDocument = TransformDocument(
            document: helper.document,
            with: SwiftUIKitBuilder())

        guard let page = helper.app, let group = page.layer(withName: "Profile") else {
            throw GenericTestFailure(description: "Unable to find the layout page")
        }
        try transformDocument.transform(layer: group)
        let generated = try transformDocument.generate()
        print(generated)
//        XCTAssert(generated ==
//        """
//        """)
    }
}
