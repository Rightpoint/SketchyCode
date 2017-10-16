//
//  VariableRef.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// A variable managed by code generation. Variables do not have names
// until code generation time, just a uniqueness identifier and a type.
struct VariableRef {
    typealias Identifier = UUID
    let identifier: Identifier
    let type: TypeRef
    var hints: [VariableGenerationHint]
}

enum VariableGenerationHint {
    case isSelf
    case isLeading
    case userHint(String)
}

extension VariableRef {
    init(ofType name: String, hints: VariableGenerationHint...) {
        self.init(identifier: UUID(), type: TypeRef(name: name), hints: hints)
    }

    var isSelf: Bool {
        return hints.contains { (hint) -> Bool in
            if case .isSelf = hint {
                return true
            }
            return false
        }
    }

    var isLeading: Bool {
        return hints.contains { (hint) -> Bool in
            if case .isLeading = hint {
                return true
            }
            return false
        }
    }

    var isImplicitSelf: Bool {
        return isSelf && isLeading
    }

    var userVariableName: String? {
        return hints.flatMap {
            if case .userHint(let value) = $0 {
                return value
            }
            return nil
        }.first
    }
}

extension VariableRef: Hashable {
    var hashValue: Int {
        return identifier.hashValue
    }
}

extension VariableRef: Equatable {
    static func ==(lhs: VariableRef, rhs: VariableRef) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.type == rhs.type
    }
}
