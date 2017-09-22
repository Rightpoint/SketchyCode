//
//  Styled.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol Styled: NSObjectProtocol {
    var style: MSStyle { get }
}

extension MSPage: Styled {}
extension MSBitmapLayer: Styled {}
extension MSLayerGroup: Styled {}
extension MSShapeGroup: Styled {}
extension MSSymbolInstance: Styled {}
extension MSSymbolMaster: Styled {}
extension MSTextLayer: Styled {}
extension MSArtboardGroup: Styled {}

