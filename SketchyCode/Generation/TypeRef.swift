//
//  TypeRef.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// TypeRef specifies the type to use
struct TypeRef {
    static var voidType = "Void"
    let name: String

    var isOptional: Bool {
        return name.hasSuffix("?")
    }
    var isVoid: Bool {
        return name == "Void"
    }

    var conformsToNSCoding: Bool {
        return true
    }

    var requiredInitializerParameters: [Parameter] {
        return [Parameter(tag: "frame", variable: VariableRef(ofType: "CGRect"))]
    }
}

extension TypeRef: ExpressibleByStringLiteral {

    init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }

    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(name: value)
    }
}

extension TypeRef: Equatable {
    static func ==(lhs: TypeRef, rhs: TypeRef) -> Bool {
        return lhs.name == rhs.name
    }
}
