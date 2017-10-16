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

extension PathContainer {
    var isASquare: Bool {
        return path.points.map { $0.point } == [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0)
        ]
    }
}

extension MSShapePathLayer: PathContainer {}
extension MSTriangleShape: PathContainer {}
extension MSPolygonShape: PathContainer {}
extension MSOvalShape: PathContainer {}
extension MSRectangleShape: PathContainer {}
extension MSStarShape: PathContainer {}
