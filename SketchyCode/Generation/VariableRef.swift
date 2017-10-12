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
    let uuid: UUID
    let type: TypeRef
}

extension VariableRef {
    init(ofType name: String) {
        self.init(uuid: UUID(), type: TypeRef(name: name))
    }
}

extension VariableRef: Hashable {
    var hashValue: Int {
        return uuid.hashValue
    }
}

extension VariableRef: Equatable {
    static func ==(lhs: VariableRef, rhs: VariableRef) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.type == rhs.type
    }
}
