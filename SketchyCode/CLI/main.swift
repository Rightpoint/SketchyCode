//
//  main.swift
//  SketchyCode
//
//  Created by Brian King on 5/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation
import Foundation
import Commander
import PathKit

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        if let path = parser.shift() {
            self.init(path)
        } else {
            throw ArgumentError.missingValue(argument: nil)
        }
    }
}

private enum ValidationError: Error, CustomStringConvertible {
    case unreadableFile(path: Path, argument: String?)
    case noTemplates
    
    public var description: String {
        switch self {
        case .noTemplates:
            return "Must specify at least one template with --templates"
        case .unreadableFile(let path, let argument):
            let suffix: String
            if let argument = argument {
                suffix = " Specify the file with \(argument)"
            } else {
                suffix = ""
            }
            return "File '\(path)' is not readable.\(suffix)"
        }
    }
}

let cmd = command(
    Flag("verbose", flag: "v", description: "Turn on verbose logging"),
    Flag("generate-classes", flag: "v", description: "Generate Swift Classes (Development / Curiosity Only)"),
    Option<Path>("file", "", description: "Path to a Sketch file"),
    VariadicOption<Path>("templates", description: "Path to templates. File or Directory."),
    Option<Path>("output", "", description: "Path to output. File or Directory. Default is current path.")
) { verbose, generateClasses, file, templates, output in
    guard file != "" && file.isReadable else {
        throw ValidationError.unreadableFile(path: file, argument: "-file")
    }
    if generateClasses {
        print(try SketchTypeBuilder.generate(at: file))
    }
    else {
        guard templates.count > 0 else {
            throw ValidationError.noTemplates
        }
        for template in templates {
            guard template.isReadable else {
                throw ValidationError.unreadableFile(path: file, argument: nil)
            }
        }

        let sketchyCode = SketchyCodeCLI(verbose: verbose, sketchPath: file, templatePaths: templates, outputPath: output)
        try sketchyCode.process()
    }
}
cmd.run(SketchyCodeCLI.version)

