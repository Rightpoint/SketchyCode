//
//  LayerContainer.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

// A layer container represents a layer that contains other MSShapeLayer.
protocol LayerContainer: AnyObject {
    var layers: [MSShapeLayer] { get set }
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

    var lowestLayer: MSShapeLayer? {
        // FIXME: Z index is reversed
        return layers.first
    }

    func removeLowestLayer() {
        layers.removeFirst()
    }
}

extension MSPage: LayerContainer {}
extension MSLayerGroup: LayerContainer {}
extension MSShapeGroup: LayerContainer {}
extension MSSymbolMaster: LayerContainer {}
extension MSArtboardGroup: LayerContainer {}

extension MSDocumentData {

    func page(withName name: String) -> MSPage? {
        return pages.first(where: { $0.name == name })
    }
}
