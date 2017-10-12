//
//  Errors.swift
//  SketchyCode
//
//  Created by Brian King on 10/11/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct UnregisteredVariableRefError: Error {
    let variable: VariableRef
}

struct UnassignedVariableRefError: Error {
    let variable: VariableRef
}
