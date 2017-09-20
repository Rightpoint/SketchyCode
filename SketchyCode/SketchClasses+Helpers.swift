//
//  SketchClasses+Helpers.swift
//  SketchyCode
//
//  Created by Brian King on 5/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

import Marshal

public typealias SketchUnknown = Any
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
// FIXME: This should really be an `MSFont` object. I'm not sure how this will behave if fonts used don't exist on the mac, but I'm pretty sure everything will be nil.
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

extension NSParagraphStyle: ValueType {
    public static func value(from inputObject: Any) throws -> Value {
        guard let object = inputObject as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: inputObject))
        }
        let style: [String: Any] = try object.value(for: "style")

        let paragraph = NSMutableParagraphStyle()
        paragraph.headerLevel = try style.value(for: "headerLevel")
        paragraph.paragraphSpacing = try style.value(for: "paragraphSpacing")
        let tabStops: [CGFloat] = try style.value(for: "tabStops")
        paragraph.tabStops = tabStops.map { NSTextTab(textAlignment: .natural, location: $0, options: [:]) }
        paragraph.headIndent = try style.value(for: "headIndent")
        paragraph.lineBreakMode = NSLineBreakMode(rawValue: try style.value(for: "lineBreakMode")) ?? .byWordWrapping
        paragraph.hyphenationFactor = try style.value(for: "hyphenationFactor")
        paragraph.alignment = NSTextAlignment(rawValue: try style.value(for: "alignment")) ?? .natural
        paragraph.paragraphSpacingBefore = try style.value(for: "paragraphSpacingBefore")
        paragraph.tailIndent = try style.value(for: "tailIndent")
        paragraph.firstLineHeadIndent = try style.value(for: "firstLineHeadIndent")
        paragraph.minimumLineHeight = try style.value(for: "minimumLineHeight")
        paragraph.lineSpacing = try style.value(for: "lineSpacing")
        paragraph.maximumLineHeight = try style.value(for: "maximumLineHeight")
        paragraph.lineHeightMultiple = try style.value(for: "lineHeightMultiple")
        paragraph.baseWritingDirection = NSWritingDirection(rawValue: try style.value(for: "baseWritingDirection")) ?? .natural
        paragraph.defaultTabInterval = try style.value(for: "defaultTabInterval")
        return paragraph
    }
}

/**
 * The expected format for NSAttributedString.
 <class>: NSConcreteAttributedString
 value: [
   <class>: NSConcreteAttributedString
   text: XXX
   attributes:
     [
       [
       location: X
       length: Y
       text: XXX // Subset of text above
       ... // NSAttributedString key / values
     ],
   ]
 ]
 */
extension NSAttributedString: ValueType {
    public static func value(from inputObject: Any) throws -> Value {
        guard let object = inputObject as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: inputObject))
        }
        if let innerValue: [String: Any] = try object.value(for: "value") {
            return try NSAttributedString.value(from: innerValue)
        } else if let text: String = try object.value(for: "text"),
            let attributes: [[String: Any]] = try object.value(for: "attributes") {
            let string = NSMutableAttributedString(string: text)
            for subStringParts in attributes {
                var subStringParts = subStringParts
                guard let length = subStringParts.removeValue(forKey: "length") as? Int,
                    let location: Int = subStringParts.removeValue(forKey: "location") as? Int,
                    let text: String = subStringParts.removeValue(forKey: "text") as? String else {
                        throw MarshalError.typeMismatch(expected: "length/location/text information", actual: subStringParts)
                }
                let range = NSRange(location: location, length: length)

                // This text can be discarded, but we'll double check it matches the length/location.
                guard text == string.attributedSubstring(from: range).string else {
                    throw MarshalError.typeMismatch(expected: "containing string does not match location / length", actual: text)
                }

                var attributes: [String: Any] = [:]

                if let font: NSFont = try subStringParts.value(for: "NSFont") {
                    attributes["NSFont"] = font
                    subStringParts.removeValue(forKey: "NSFont")
                }
                if let color: NSColor = try subStringParts.value(for: "NSColor") {
                    attributes["NSColor"] = color
                    subStringParts.removeValue(forKey: "NSColor")
                }
                for intKey in ["NSStrikethrough", "NSLigature", "NSUnderline", "NSSuperScript"] {
                    if let numericRepresentation: Int = try subStringParts.value(for: intKey) {
                        attributes[intKey] = numericRepresentation
                        subStringParts.removeValue(forKey: intKey)
                    }
                }
                for floatKey in ["NSKern", "NSBaselineOffset"] {
                    if let kern: CGFloat = try subStringParts.value(for: floatKey) {
                        attributes[floatKey] = kern
                        subStringParts.removeValue(forKey: floatKey)
                    }
                }

                if let paragraphStyle: NSParagraphStyle = try subStringParts.value(for: "NSParagraphStyle") {
                    attributes["NSParagraphStyle"] = paragraphStyle
                    subStringParts.removeValue(forKey: "NSParagraphStyle")
                }

                // Not sure how to represent this in NSAttributedString
                subStringParts.removeValue(forKey: "MSAttributedStringTextTransformAttribute")

                // Double check that there are no keys we don't know about.
                guard subStringParts.count == 0 else {
                    throw MarshalError.typeMismatch(expected: "Not all attributes extracted", actual: subStringParts)
                }

                string.setAttributes(attributes, range: range)
            }
            return string
        } else {
            throw MarshalError.keyNotFound(key: "text/attributes or value")
        }
    }
}
