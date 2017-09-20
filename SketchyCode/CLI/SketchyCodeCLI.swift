//
//  SketchyCodeCLI.swift
//  SketchyCode
//
//  Created by Brian King on 5/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation
import PathKit
import Marshal
import StencilSwiftKit
import Stencil

import SketchyCode

class SketchyCodeCLI {
    static let version: String = "0.suspect"
    
    fileprivate let verbose: Bool
    fileprivate let sketchPath: Path
    fileprivate let templatePaths: [Path]
    fileprivate let outputPath: Path

    init(verbose: Bool, sketchPath: Path, templatePaths: [Path], outputPath: Path) {
        self.verbose = verbose
        self.sketchPath = sketchPath
        self.templatePaths = templatePaths
        self.outputPath = outputPath
    }
    
    func process() throws {
        let command = Command("/usr/local/bin/sketchtool", arguments: "dump", sketchPath.string)
        let output = command.execute()
        let json = try JSONSerialization.jsonObject(with: output, options: [])

        guard let object = json as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String: Any].self, actual: json)
        }

        let document = try MSDocumentData(object: object)

        let stencilExtension = Extension()
        stencilExtension.registerStencilSwiftExtensions()
        // FIXME: this should be in a macro
        stencilExtension.registerFilter("printParagraphStyleConfiguration") { (value, array) -> Any? in
            guard let paragraphStyle = value as? NSParagraphStyle else {
                throw SketchyError.invalidArgument(expected: "NSParagraphStyle", filter: "configureParagraphStyle", value: value)
            }
            guard let variable = array.first as? String else {
                throw SketchyError.invalidArgument(expected: "variable name", filter: "configureParagraphStyle", value: array.first ?? "nil")
            }
            let defaults = NSParagraphStyle.default()
            var configuration = ""
            func dumpConfiguration<T: Equatable>(key: String, value: (NSParagraphStyle) -> T) {
                let newValue = value(paragraphStyle)
                guard value(defaults) != newValue else {
                    return
                }
                configuration.append("\(variable).\(key) = \(newValue)")
            }
            dumpConfiguration(key: "lineSpacing", value: { $0.lineSpacing })
            dumpConfiguration(key: "paragraphSpacing", value: { $0.paragraphSpacing })
            dumpConfiguration(key: "headIndent", value: { $0.headIndent })
            dumpConfiguration(key: "tailIndent", value: { $0.tailIndent })
            dumpConfiguration(key: "minimumLineHeight", value: { $0.minimumLineHeight })
            dumpConfiguration(key: "maximumLineHeight", value: { $0.maximumLineHeight })
            dumpConfiguration(key: "lineHeightMultiple", value: { $0.lineHeightMultiple })
            dumpConfiguration(key: "paragraphSpacingBefore", value: { $0.paragraphSpacingBefore })
            dumpConfiguration(key: "hyphenationFactor", value: { $0.hyphenationFactor })
            dumpConfiguration(key: "defaultTabInterval", value: { $0.defaultTabInterval })
            dumpConfiguration(key: "allowsDefaultTighteningForTruncation", value: { $0.allowsDefaultTighteningForTruncation })
            dumpConfiguration(key: "tighteningFactorForTruncation", value: { $0.tighteningFactorForTruncation })
            dumpConfiguration(key: "headerLevel", value: { $0.headerLevel })

//            dumpConfiguration(key: "baseWritingDirection", value: { $0.baseWritingDirection }, isEnum: true)
//            dumpConfiguration(key: "lineBreakMode", value: { $0.lineBreakMode }, isEnum: true)
//            dumpConfiguration(key: "alignment", value: { $0.alignment }, isEnum: true)

            return configuration
        }

        for templatePath in templatePaths {
            let data = try Data(contentsOf: templatePath.url, options: [])
            guard let stencilString = String(data: data, encoding: String.Encoding.utf8) else {
                throw ParserError.canNotLoadClassStencil
            }
            let template = StencilSwiftTemplate(templateString: stencilString, environment: Environment(extensions: [stencilExtension]), name: nil)
            let generated = try template.render(["document": document])

            if outputPath == "" {
                print(generated)
            }
            else {
                let newFile = templatePath.lastComponentWithoutExtension.appending(".swift")
                let newURL = URL(fileURLWithPath: outputPath.string + "/" + newFile)

                try generated.data(using: .utf8)?.write(to: newURL)
            }
        }

    }
}


enum SketchyError: Error, CustomStringConvertible {
    case invalidArgument(expected: String, filter: String, value: Any?)

    public var description: String {
        switch self {
        case .invalidArgument(let expected, let filter, let value):
            return "Filter '\(filter)' expected \(expected), not \(value ?? "nil")"
        }
    }
}
