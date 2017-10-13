//
//  Helpers.swift
//  SketchyCode
//
//  Created by Brian King on 10/13/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

extension MSRect {
    func asCGRect() -> String {
        return "CGRect(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}

struct ResizeOptions: OptionSet {
    var rawValue: Int
    static var none                 = ResizeOptions(rawValue: 0)
    static var flexibleLeftMargin   = ResizeOptions(rawValue: 1 << 0)
    static var flexibleWidth        = ResizeOptions(rawValue: 1 << 1)
    static var flexibleRightMargin  = ResizeOptions(rawValue: 1 << 2)
    static var flexibleTopMargin    = ResizeOptions(rawValue: 1 << 3)
    static var flexibleHeight       = ResizeOptions(rawValue: 1 << 4)
    static var flexibleBottomMargin = ResizeOptions(rawValue: 1 << 5)
};
