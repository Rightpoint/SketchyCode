//
//  SketchClasses+Helpers.swift
//  SketchyCode
//
//  Created by Brian King on 5/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

import Marshal

typealias SketchUnknown = Any
extension CGFloat: ValueType {}
extension CGPoint: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.x = try object.value(for: "x")
        self.y = try object.value(for: "y")
    }
}
extension CGSize: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.width = try object.value(for: "width")
        self.height = try object.value(for: "height")
    }
}
extension NSFont: ValueType {
    public static func value(from object: Any) throws -> Value {
        guard let obj = object as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: object))
        }
        let attrs: [String: Any] = try obj.value(for: "attributes")
        guard let font = NSFont(
            name: try attrs.value(for: "NSFontNameAttribute"),
            size: try attrs.value(for: "NSFontSizeAttribute")
            ) else {
                throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: object))
        }
        return font
    }
}
extension NSColor: ValueType {
    // "rgba(0,0,0,0.15)"
    // "#FFFFFF"
    public static func value(from object: Any) throws -> Value {
        guard let obj = object as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: object))
        }
        let value: String = try obj.value(for: "value") ?? obj.value(for: "color")
        if value.characters.first == "#" {
            return try parse(hex: value)
        }
        else {
            return try parse(command: value)
        }
    }
    
    static func parse(command: String) throws -> NSColor {
        let parts = command.components(separatedBy: CharacterSet(charactersIn: "()"))
        let cmd = parts[0]
        let levels = parts[1].components(separatedBy: ",")
            .map(Double.init).flatMap() { $0 }
            .map() { CGFloat($0) }.flatMap() { $0 }
        switch (cmd, levels) {
        case ("rgba", let levels) where levels.count == 4:
            return NSColor(red: levels[0], green: levels[1], blue: levels[2], alpha: levels[3])
        default:
            throw MarshalError.typeMismatch(expected: "NSColor", actual: command)
        }
    }
    
    static func parse(hex: String) throws -> NSColor {
        // map over hex-string pairs
        let rgb = (0..<3).map() { (index: Int) -> String in
            let (start, end) = (
                hex.index(hex.startIndex, offsetBy: (2 * index)),
                hex.index(hex.startIndex, offsetBy: (2 * index) + 2)
            )
            return hex[start..<end]
        // Scan into integers
        }.map() { (chunk: String) -> UInt32 in
            var scanInt: UInt32 = 0
            Scanner(string: chunk).scanHexInt32(&scanInt)
            return scanInt
        // Convert to floats
        }.map() { (scan: UInt32) -> CGFloat in
            return CGFloat(scan) / 255.0
        }
        
        return NSColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
    }
}

// FIXME: Implement NSParagraphStyle: ValueType
extension NSParagraphStyle: ValueType {
    public static func value(from object: Any) throws -> Value {
        return NSParagraphStyle()
    }
}

// FIXME: Implement NSAttributedString: ValueType
extension NSAttributedString: ValueType {
    public static func value(from object: Any) throws -> Value {
        return NSAttributedString()
    }
}

