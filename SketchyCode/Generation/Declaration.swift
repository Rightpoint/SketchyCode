//
//  Declaration.swift
//  SketchyCode
//
//  Created by Brian King on 10/5/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

enum Declaration {
    case variable(Object)
    case type(ObjectType)
//    case function(ObjectType)

    var object: Object? {
        switch self {
        case .variable(let object): return object
        case .type /*, .function */: return nil
        }
    }
}

extension Declaration: Equatable {
    static func ==(lhs: Declaration, rhs: Declaration) -> Bool {
        switch (lhs, rhs) {
        case (.variable(let lhsObj), .variable(let rhsObj)):
            return lhsObj == rhsObj
        case (.type(let lhsType), .type(let rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
}
