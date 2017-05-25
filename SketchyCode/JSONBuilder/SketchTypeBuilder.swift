//
//  SketchTypes.swift
//  SketchyCode
//
//  Created by Brian King on 5/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation
import PathKit
import StencilSwiftKit

/// This is some exploratory code to create usable swift objects from sketchtool JSON.
/// These generated swift objects will be responsible for actually importing the Sketch 
/// file. By generating the Sketch model files from Sketch JSON, it will be easier to 
/// cover the full scope of Sketch, support API changes and possibly support plugins.
final class SketchTypeBuilder {

    static func generate(at path: Path) throws -> String {
        let command = Command("/usr/local/bin/sketchtool", arguments: "dump", path.string)
        let output = command.execute()
        let json = try JSONSerialization.jsonObject(with: output, options: [])
        
        let document = try SketchTypeDocument(any: json)
        guard let stencilURL = Bundle(for: SketchTypeBuilder.self).url(forResource: "SketchClass", withExtension: "stencil") else {
            throw ParserError.canNotLoadClassStencil
        }
        let data = try Data(contentsOf: stencilURL, options: [])
        guard let stencilString = String(data: data, encoding: String.Encoding.utf8) else {
            throw ParserError.canNotLoadClassStencil
        }
        let template = StencilSwiftTemplate(templateString: stencilString)
        let generated = try template.render(["document": document])
        return generated
    }
}

final class SketchClass: NSObject {
    final class Attribute: NSObject {
        let name: String
        var type: SketchType
        init (name: String, type: SketchType) {
            self.name = name
            self.type = type
        }
        var swiftType: String {
            return type.swiftType
        }
    }

    let parent: SketchClass?
    let name: String
    var attributes: [Attribute]

    var allAttributes: [Attribute] {
        var allAttributes: [Attribute] = attributes
        if let parent = parent {
            allAttributes.append(contentsOf: parent.allAttributes)
        }
        return allAttributes
    }
   
    static var classMarker = "<class>"
    
    init(name: String, parent: SketchClass?) {
        self.name = name
        self.parent = parent
        self.attributes = []
    }
    
    func lookup(attribute name: String) -> Attribute? {
        for attr in attributes {
            if attr.name == name {
                return attr
            }
        }
        return nil
    }
    
    func update(json: [String: Any], document: SketchTypeDocument) throws {
        for (key, value) in json {
            guard let key = document.lookupAttribute(for: key) else { continue }
            let attribute = lookup(attribute: key) ?? {
                let newAttribute = Attribute(name: key, type: .unknown)
                attributes.append(newAttribute)
                return newAttribute
            }()
            let new = try SketchType(any: value, document: document, keyHint: key)
            try attribute.type.update(new: new, document: document)
        }
    }
}

indirect enum SketchType: Equatable {
    case builtin(String)
    case `class`(SketchClass)
    case array(SketchType)
    
    // This is for null properties can be encounterd or if keys are not supplied for null entries.
    // This may not be required
    case optional(SketchType)
    case unknown
    
    init(any: Any, document: SketchTypeDocument, keyHint: String = "") throws {
        if let type = document.propertyTypes[keyHint] {
            self = .builtin(type)
        }
        switch any {
        case is Int where keyHint.hasPrefix("is") || keyHint.hasPrefix("should") || keyHint.hasPrefix("has"):
            self = .builtin("Bool")
        case is CGFloat:
            self = .builtin("CGFloat")
        case is String:
            self = .builtin("String")
        case let json as [String: Any]:
            self = try document.loadJSON(json: json)
        case let array as [Any]:
            let types = try array.map { try SketchType(any: $0, document: document) }
            self = .array(types.first ?? .unknown)
        default:
            throw ParserError.unknownType(any)
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    mutating func update(new: SketchType, document: SketchTypeDocument) throws {
        switch (self, new) {
        // No-Op equality
        case (_, _) where self == new:
            break
        // If we are unknown, take new value
        case (.unknown, _):
            self = new
        case (.array(.unknown), .array(_)):
            self = new
        case (.optional(.unknown), .optional(_)):
            self = new
        // not sure if this will ever fire.
        case (.builtin("Int"), .builtin("Float")):
            self = new
        // If the new value is unknown skip it
        case (_, .unknown):
            break
        case (_, .array(.unknown)):
            break
        case (_, .optional(.unknown)):
            break
        // Check for subclasses
        case (.array(.class(let cur)), .array(.class(let new))):
            let container = document.containerClass(of: cur, and: new)
            self = .array(.class(container))
        case (.class(let cur), .class(let new)):
            let container = document.containerClass(of: cur, and: new)
            self = .class(container)
        case (.builtin(let cur), .builtin(let new)):
            let container = document.containerClass(of: cur, and: new)
            self = .builtin(container)
        default:
            throw ParserError.unknownTypeAlteration(original: self, new: new)
        }
    }
    
    public static func == (lhs: SketchType, rhs: SketchType) -> Bool {
        switch (lhs, rhs) {
        case (.builtin(let lhsType), .builtin(let rhsType)):
            return lhsType == rhsType
        case (.unknown, .unknown):
            return true
        case (.class(let lhsClass), .class(let rhsClass)):
            return lhsClass.name == rhsClass.name
        case (.array(let lhsType), .array(let rhsType)):
            return lhsType == rhsType
        case (.optional(let lhsType), .optional(let rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
    
    var swiftType: String {
        switch self {
        case .builtin(let type):
            return type
        case .class(let sketchClass):
            return sketchClass.name
        case .array(let type):
            return "[\(type.swiftType)]"
        case .optional(let type):
            return "\(type.swiftType)?"
        case .unknown:
            return "SketchUnknown"
        }
    }
}

final class SketchTypeDocument: NSObject {
    // This is a mapping of Sketch classes that the document is attempting to build up.
    var byName: [String: SketchClass] = [:]
    
    var classes: [SketchClass] {
        return byName.sorted { lhs, rhs in
            return lhs.key < rhs.key
        }.map() { $0.value }
    }
    
    // This is a collection of classes that are provided by the system and should not
    // be collected by SketchClass.
    let builtinClasses: [String: String] = [
        "NSConcreteAttributedString": "NSAttributedString",
        "NSMutableParagraphStyle": "NSParagraphStyle",
        "NSParagraphStyle": "NSParagraphStyle",
        "NSColor": "NSColor"
    ]
    
    // Some of the collections persist a class hierarchy, where the type may differ between
    // items in the collection. This will override the container mapping to use.
    let superclassMappings: [String: String] = [
        "NSMutableParagraphStyle": "NSParagraphStyle",
        "MSRectangleShape": "MSShapeLayer",
        "MSShapePathLayer": "MSShapeLayer",
        "MSShapeGroup": "MSShapeLayer",
        "MSOvalShape": "MSShapeLayer",
        "MSLayerGroup": "MSShapeLayer",
        "MSTextLayer": "MSShapeLayer",
        "MSBitmapLayer": "MSShapeLayer"
    ]
    
    let propertyTypes: [String: String] =  [
        "objectID": "NSUUID",
        "edited": "Bool",
        "resizesContent": "Bool",
        "shouldTrim": "Bool",
        "includeInCloudUpload": "Bool",
        "includeBackgroundColorInInstance": "Bool",
        "includeBackgroundColorInExport": "Bool",
        "constrainProportions": "Bool"
    ]
    init(any: Any) throws {
        super.init()
        _ = try SketchType(any: any, document: self)
        consolidateClassAttributes()
    }
}

// Extension to assist with JSON loading and attribute / class lookup.
private extension SketchTypeDocument {
    /// This load method allows the same SketchClass to be updated with every JSON blob
    /// with a matching class name in the dump file. The SketchClass will accumulate all
    /// permutations of interest. This should allow it to detect optionality as long as
    /// the property is empty once and the types of to-many relationships as long as they
    /// are non-empty once.
    func loadJSON(json: [String: Any]) throws -> SketchType {
        if let name = json[SketchClass.classMarker] as? String {
            if let builtinName = builtinClasses[name] {
                return .builtin(builtinName)
            }
            let sketchClass = lookupClass(for: name)
            try sketchClass.update(json: json, document: self)
            return .class(sketchClass)
        } else if json["x"] != nil && json["y"] != nil {
            return .builtin("CGPoint")
        } else if json["height"] != nil && json["width"] != nil {
            return .builtin("CGSize")
        } else if json["paragraphSpacingBefore"] != nil && json["tabStops"] != nil {
            return .builtin("NSParagraphStyle")
        } else if json["family"] != nil && json["name"] != nil {
            return .builtin("NSFont")
        } else {
            // One key 'overrides' looks like it wants to be a dictionary.
            return .builtin("[String: Any]")
        }
    }
    
    func lookupAttribute(for name: String) -> String? {
        if name == SketchClass.classMarker {
            return nil
        }
        // If the attribute name is a builtin class, remove it's NS prefix. This
        // easily cleans up some attributes named NSColor, NSParagraphStyle and NSFont
        if builtinClasses[name] != nil {
            var name = name
            let indicies = name.characters.indices
            let firstIndex = indicies.startIndex
            let lowerIndex = indicies.index(after: indicies.index(after: firstIndex))
            let toLower = name.characters[lowerIndex]
            name.replaceSubrange(firstIndex...lowerIndex, with: String(toLower).lowercased())
            return name
        }
        return name
    }
    
    func lookupClass(for name: String) -> SketchClass {
        let sketchClass = byName[name] ?? {
            let parent = byName[superclassMappings[name] ?? "No Super Class Key"]
            let newClass = SketchClass(name: name, parent: parent)
            byName[name] = newClass
            return newClass
            }()
        return sketchClass
    }
    
    func containerClass(of name: String, and otherName: String) -> String {
        let container = superclassMappings[name] ?? name
        let other = superclassMappings[otherName] ?? otherName
        if container != other {
            print("Assuming that \(container) and \(other) are subclasses, add an explicit mapping")
        }
        return container
    }
    
    func containerClass(of sketchClass: SketchClass, and otherSketchClass: SketchClass) -> SketchClass {
        let name = containerClass(of: sketchClass.name, and: otherSketchClass.name)
        return lookupClass(for: name)
    }
}

// Extension to consolidate attributes into the specified superclass
private extension SketchTypeDocument {
    // Helper class to determine shared attributes for a set of subclasses
    class AttributeCounter {
        var subclasses: [SketchClass] = []
        var attributeToCount: [String: Int] = [:]
        
        func count(subclass: SketchClass) {
            subclasses.append(subclass)
            for (attr) in subclass.attributes {
                var count = attributeToCount[attr.name] ?? 0
                count += 1
                attributeToCount[attr.name] = count
            }
        }
        var commonAttributes: [String] {
            return attributeToCount.filter { $0.value == subclasses.count }.map { $0.key }
        }
    }
    
    func consolidateClassAttributes() {
        var superClassCounters: [String: AttributeCounter] = [:]
        
        for sketchClass in byName.values {
            guard let parent = sketchClass.parent else { continue }
            let counter = superClassCounters[parent.name] ?? AttributeCounter()
            superClassCounters[parent.name] = counter
            counter.count(subclass: sketchClass)
        }
        for (superclassName, counter) in superClassCounters {
            let baseclass = lookupClass(for: superclassName)
            let subclass = counter.subclasses[0]
            // Transfer the attributes to the subclass
            for attributeName in counter.commonAttributes {
                guard let attribute = subclass.lookup(attribute: attributeName) else {
                    fatalError("Should always have item in attributes list")
                }
                baseclass.attributes.append(attribute)

                for subclass in counter.subclasses {
                    guard let index = subclass.attributes.index(where: { $0.name == attributeName}) else {
                        fatalError("Should always have item in attributes list")
                    }
                    subclass.attributes.remove(at: index)
                }
            }
        }
    }
}

// attributes was not exposed in the Stencil correctly, not sure why.
// Expose what we actually need in NSCoding friendly types.
extension SketchClass {
    dynamic var attributeTypes: [String: String] {
        var attributeTypes: [String: String] = [:]
        for attribute in attributes {
            attributeTypes[attribute.name] = attribute.type.swiftType
        }
        return attributeTypes
    }
}

enum ParserError: Error, CustomStringConvertible {
    case unknownType(Any)
    case unknownTypeAlteration(original: SketchType, new: SketchType)
    case unknownJSONObject([String: Any])
    case canNotLoadClassStencil

    public var description: String {
        switch self {
        case let .unknownType(any):
            return "Unknown type: \(any)"
        case let .unknownTypeAlteration(original, value):
            return "Unknown type alteration: \(original) -> \(value)"
        case .unknownJSONObject(let dictionary):
            return "Dictionary is not a class: \"\(dictionary)\""
        case .canNotLoadClassStencil:
            return "Can not load SketchClass.stencil"
        }
    }
}
