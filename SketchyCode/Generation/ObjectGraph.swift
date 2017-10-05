//
//  ObjectGraph.swift
//  SketchyCode
//
//  Created by Brian King on 10/3/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

struct ObjectType {
    let name: String

    var simpleName: String {
        // prune namespace and camel case
        return name
    }
}

struct Object {
    let uuid = UUID()
    let type: ObjectType

    // To generate decent variable names, the object will have some hints to
    // help create a useful name beyond the ObjectType
    var hints: [NameHint] = []
}

extension Object {
    init(ofType name: String) {
        self.init(type: ObjectType(name: name), hints: [])
    }
    enum NameHint {
        case hint(String)
    }
}

extension Object {
    func generateName() -> String {
        return type.simpleName
    }
}

struct DeclarationReference {
    private static let selfTag = ""

    let object: Object
    let name: String

    init(withSelf object: Object) {
        self.object = object
        self.name = DeclarationReference.selfTag
    }

    init(value: String, object: Object) {
        self.name = value
        self.object = object
    }

    var isGlobal: Bool {
        guard let firstChar = name.characters.first else { return false }
        let first = String(firstChar)
        return first.uppercased() != first
    }

    var isSelf: Bool {
        return name == DeclarationReference.selfTag
    }
}

class Graph {
    let document: MSDocumentData
    var objects: [Object] = []

    init(document: MSDocumentData) {
        self.document = document
    }
}
