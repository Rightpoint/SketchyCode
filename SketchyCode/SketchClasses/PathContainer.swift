//
//  PathContainer.swift
//  SketchyCode
//
//  Created by Brian King on 9/20/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

protocol PathContainer {
    var path: MSShapePath { get }
}

extension MSShapePathLayer: PathContainer {}
extension MSTriangleShape: PathContainer {}
extension MSPolygonShape: PathContainer {}
extension MSOvalShape: PathContainer {}
extension MSRectangleShape: PathContainer {}
extension MSStarShape: PathContainer {}
