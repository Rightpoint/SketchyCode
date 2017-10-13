//
//  InputSketchHelper.swift
//  SketchyCode
//
//  Created by Brian King on 9/19/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation
@testable import SketchyCode

class InputSketchHelper {
    class var bundle: Bundle {
        return Bundle(for: InputSketchHelper.self)
    }

    // sketchtool dump InputSketch.sketch > .//SketchyCodeTests/InputSketch.dump.json
    static var JSON: [String: Any] = {
        guard let URL = bundle.url(forResource: "InputSketch.dump", withExtension: "json") else {
            fatalError("File does not exist")
        }
        do {
            let data = try Data(contentsOf: URL)
            guard let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                fatalError("JSON File does not contain a dictionary")
            }
            return JSON
        } catch {
            fatalError("Unable to load data \(error)")
        }
    }()

    let document: MSDocumentData
    init(document: MSDocumentData) {
        self.document = document
    }

    convenience init() throws {
        do {
            self.init(document: try MSDocumentData(object: InputSketchHelper.JSON))
        } catch {
            print(error)
            throw error
        }
    }

    var shape: MSPage? { return document.page(withName: "Shape") }
    var layout: MSPage? { return document.page(withName: "Layout") }
    var fill: MSPage? { return document.page(withName: "Fill") }
    var border: MSPage? { return document.page(withName: "Border") }
    var shadow: MSPage? { return document.page(withName: "Shadow") }
    var combine: MSPage? { return document.page(withName: "Combine") }
    var transform: MSPage? { return document.page(withName: "Transform") }
    var text: MSPage? { return document.page(withName: "Text") }
    var images: MSPage? { return document.page(withName: "Images") }
    var artboard: MSPage? { return document.page(withName: "Artboard") }
    var symbols: MSPage? { return document.page(withName: "Symbols") }
    var app: MSPage? { return document.page(withName: "App") }
}
