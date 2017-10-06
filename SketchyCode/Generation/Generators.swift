//
//  Generators.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol Generator {
    func generate(in context: Scope, writer: Writer) throws
}
