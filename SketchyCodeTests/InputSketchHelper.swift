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

    func page(withName name: String) -> MSPage? {
        return document.pages.first(where: { $0.name == name })
    }

    var shape: MSPage? { return page(withName: "Shape") }
    var layout: MSPage? { return page(withName: "Layout") }
    var fill: MSPage? { return page(withName: "Fill") }
    var border: MSPage? { return page(withName: "Border") }
    var shadow: MSPage? { return page(withName: "Shadow") }
    var combine: MSPage? { return page(withName: "Combine") }
    var transform: MSPage? { return page(withName: "Transform") }
    var text: MSPage? { return page(withName: "Text") }
    var images: MSPage? { return page(withName: "Images") }
    var artboard: MSPage? { return page(withName: "Artboard") }
    var symbols: MSPage? { return page(withName: "Symbols") }
}
