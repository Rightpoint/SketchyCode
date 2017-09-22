//
//  Helpers.swift
//  SketchyCode
//
//  Created by Brian King on 9/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import XCTest

extension Optional {
    struct UnexpectedNil: Error {}
    struct InvalidCast: Error {}

    func unwrapped(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        guard case .some(let value) = self else {
            XCTFail("Unexpected nil", file: file, line: line)
            throw UnexpectedNil()
        }
        return value
    }

    func unwrapped<T>(as type: T.Type, file: StaticString = #file, line: UInt = #line) throws -> T {
        guard case .some(let value) = self else {
            XCTFail("Unexpected nil", file: file, line: line)
            throw UnexpectedNil()
        }
        guard let typedValue = value as? T else {
            XCTFail("Unable to cast to \(type)", file: file, line: line)
            throw InvalidCast()
        }
        return typedValue
    }
}
