//
//  LayerContainer.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol LayerContainer {
    var layers: [MSShapeLayer] { get }
}

extension LayerContainer {
    func layer(withName name: String, recursive: Bool = false) -> MSShapeLayer? {
        for layer in layers {
            if layer.name == name {
                return layer
            }
        }
        if recursive {
            for layer in layers {
                if let container = layer as? LayerContainer {
                    if let sublayer = container.layer(withName: name, recursive: true) {
                        return sublayer
                    }
                }
            }
        }
        return nil
    }

    var visibleLayers: [MSShapeLayer] {
        return layers.filter({ $0.isVisible })
    }
}

extension MSPage: LayerContainer {}
extension MSLayerGroup: LayerContainer {}
extension MSShapeGroup: LayerContainer {}
extension MSSymbolMaster: LayerContainer {}

extension MSDocumentData {

    func page(withName name: String) -> MSPage? {
        return pages.first(where: { $0.name == name })
    }
}
