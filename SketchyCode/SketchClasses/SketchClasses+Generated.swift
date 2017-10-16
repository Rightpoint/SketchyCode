// This file is generated automatically, DO NOT EDIT

import CoreGraphics
import AppKit
import Marshal

public class MSArtboardGroup: MSShapeLayer {

    public var resizesContent: CGFloat
    public var includeInCloudUpload: Bool
    public var backgroundColor: MSColor
    public var style: MSStyle
    public var layers: [MSShapeLayer]
    public var horizontalRulerData: MSRulerData
    public var hasBackgroundColor: Bool
    public var includeBackgroundColorInExport: Bool
    public var verticalRulerData: MSRulerData
    public var hasClickThrough: Bool
    public var grid: MSSimpleGrid?
    public var layout: MSLayoutGrid?

    public required init(object: MarshaledObject) throws {
        self.resizesContent = try object.value(for: "resizesContent")
        self.includeInCloudUpload = try object.value(for: "includeInCloudUpload")
        self.backgroundColor = try object.value(for: "backgroundColor")
        self.style = try object.value(for: "style")
        self.layers = try object.value(for: "layers")
        self.horizontalRulerData = try object.value(for: "horizontalRulerData")
        self.hasBackgroundColor = try object.value(for: "hasBackgroundColor")
        self.includeBackgroundColorInExport = try object.value(for: "includeBackgroundColorInExport")
        self.verticalRulerData = try object.value(for: "verticalRulerData")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.grid = try object.value(for: "grid")
        self.layout = try object.value(for: "layout")

        try super.init(object: object)
    }

}

public class MSAssetCollection: NSObject, Unmarshaling {

    public var gradients: [SketchUnknown]
    public var colors: [SketchUnknown]
    public var images: [SketchUnknown]
    public var imageCollection: MSImageCollection

    public required init(object: MarshaledObject) throws {
        self.gradients = try object.value(for: "gradients")
        self.colors = try object.value(for: "colors")
        self.images = try object.value(for: "images")
        self.imageCollection = try object.value(for: "imageCollection")
    }

}

public class MSBitmapLayer: MSShapeLayer {

    public var style: MSStyle
    public var clippingMask: CGPoint
    public var image: MSImageData
    public var nineSliceScale: CGSize
    public var fillReplacesImage: CGFloat
    public var nineSliceCenterRect: CGPoint

    public required init(object: MarshaledObject) throws {
        self.style = try object.value(for: "style")
        self.clippingMask = try object.value(for: "clippingMask")
        self.image = try object.value(for: "image")
        self.nineSliceScale = try object.value(for: "nineSliceScale")
        self.fillReplacesImage = try object.value(for: "fillReplacesImage")
        self.nineSliceCenterRect = try object.value(for: "nineSliceCenterRect")

        try super.init(object: object)
    }

}

public class MSColor: NSObject, Unmarshaling {

    public var value: String

    public required init(object: MarshaledObject) throws {
        self.value = try object.value(for: "value")
    }
}

public class MSCurvePoint: NSObject, Unmarshaling {

    public var hasCurveTo: Bool
    public var curveFrom: CGPoint
    public var curveTo: CGPoint
    public var curveMode: CGFloat
    public var hasCurveFrom: Bool
    public var cornerRadius: CGFloat
    public var point: CGPoint

    public required init(object: MarshaledObject) throws {
        self.hasCurveTo = try object.value(for: "hasCurveTo")
        self.curveFrom = try object.value(for: "curveFrom")
        self.curveTo = try object.value(for: "curveTo")
        self.curveMode = try object.value(for: "curveMode")
        self.hasCurveFrom = try object.value(for: "hasCurveFrom")
        self.cornerRadius = try object.value(for: "cornerRadius")
        self.point = try object.value(for: "point")
    }

}

public class MSDocumentData: NSObject, Unmarshaling {

    public var foreignSymbols: [SketchUnknown]
    public var layerStyles: MSSharedStyleContainer
    public var objectID: String
    public var currentPageIndex: CGFloat
    public var enableLayerInteraction: Bool
    public var layerSymbols: MSSymbolContainer
    public var assets: MSAssetCollection
    public var enableSliceInteraction: Bool
    public var layerTextStyles: MSSharedTextStyleContainer
    public var pages: [MSPage]

    public required init(object: MarshaledObject) throws {
        self.foreignSymbols = try object.value(for: "foreignSymbols")
        self.layerStyles = try object.value(for: "layerStyles")
        self.objectID = try object.value(for: "objectID")
        self.currentPageIndex = try object.value(for: "currentPageIndex")
        self.enableLayerInteraction = try object.value(for: "enableLayerInteraction")
        self.layerSymbols = try object.value(for: "layerSymbols")
        self.assets = try object.value(for: "assets")
        self.enableSliceInteraction = try object.value(for: "enableSliceInteraction")
        self.layerTextStyles = try object.value(for: "layerTextStyles")
        self.pages = try object.value(for: "pages")
    }

}

public class MSExportFormat: NSObject, Unmarshaling {

    public var fileFormat: String
    public var name: String
    public var namingScheme: CGFloat
    public var visibleScaleType: CGFloat
    public var scale: CGFloat
    public var absoluteSize: CGFloat

    public required init(object: MarshaledObject) throws {
        self.fileFormat = try object.value(for: "fileFormat")
        self.name = try object.value(for: "name")
        self.namingScheme = try object.value(for: "namingScheme")
        self.visibleScaleType = try object.value(for: "visibleScaleType")
        self.scale = try object.value(for: "scale")
        self.absoluteSize = try object.value(for: "absoluteSize")
    }

}

public class MSExportOptions: NSObject, Unmarshaling {

    public var layerOptions: CGFloat
    public var exportFormats: [MSExportFormat]
    public var includedLayerIds: [SketchUnknown]
    public var shouldTrim: Bool

    public required init(object: MarshaledObject) throws {
        self.layerOptions = try object.value(for: "layerOptions")
        self.exportFormats = try object.value(for: "exportFormats")
        self.includedLayerIds = try object.value(for: "includedLayerIds")
        self.shouldTrim = try object.value(for: "shouldTrim")
    }

}

public class MSGradient: NSObject, Unmarshaling {

    public var gradientType: CGFloat
    public var from: CGPoint
    public var shouldSmoothenOpacity: Bool
    public var stops: [MSGradientStop]
    public var to: CGPoint
    public var elipseLength: CGFloat

    public required init(object: MarshaledObject) throws {
        self.gradientType = try object.value(for: "gradientType")
        self.from = try object.value(for: "from")
        self.shouldSmoothenOpacity = try object.value(for: "shouldSmoothenOpacity")
        self.stops = try object.value(for: "stops")
        self.to = try object.value(for: "to")
        self.elipseLength = try object.value(for: "elipseLength")
    }

}

public class MSGradientStop: NSObject, Unmarshaling {

    public var color: MSColor
    public var position: CGFloat

    public required init(object: MarshaledObject) throws {
        self.color = try object.value(for: "color")
        self.position = try object.value(for: "position")
    }

}

public class MSGraphicsContextSettings: NSObject, Unmarshaling {

    public var blendMode: CGFloat
    public var opacity: CGFloat

    public required init(object: MarshaledObject) throws {
        self.blendMode = try object.value(for: "blendMode")
        self.opacity = try object.value(for: "opacity")
    }

}

public class MSImageCollection: NSObject, Unmarshaling {

    public var images: [SketchUnknown]

    public required init(object: MarshaledObject) throws {
        self.images = try object.value(for: "images")
    }

}

public class MSImageData: NSObject, Unmarshaling {

    public var size: String
    public var sha1: String

    public required init(object: MarshaledObject) throws {
        self.size = try object.value(for: "size")
        self.sha1 = try object.value(for: "sha1")
    }

}

public class MSLayerGroup: MSShapeLayer {

    public var style: MSStyle
    public var layers: [MSShapeLayer]
    public var hasClickThrough: Bool

    public required init(object: MarshaledObject) throws {
        self.style = try object.value(for: "style")
        self.layers = try object.value(for: "layers")
        self.hasClickThrough = try object.value(for: "hasClickThrough")

        try super.init(object: object)
    }

}

public class MSLayoutGrid: NSObject, Unmarshaling {

    public var isEnabled: Bool
    public var gutterWidth: CGFloat
    public var horizontalOffset: CGFloat
    public var drawHorizontalLines: CGFloat
    public var drawVertical: CGFloat
    public var drawHorizontal: CGFloat
    public var totalWidth: CGFloat
    public var rowHeightMultiplication: CGFloat
    public var numberOfColumns: CGFloat
    public var gutterHeight: CGFloat
    public var guttersOutside: CGFloat
    public var columnWidth: CGFloat

    public required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.gutterWidth = try object.value(for: "gutterWidth")
        self.horizontalOffset = try object.value(for: "horizontalOffset")
        self.drawHorizontalLines = try object.value(for: "drawHorizontalLines")
        self.drawVertical = try object.value(for: "drawVertical")
        self.drawHorizontal = try object.value(for: "drawHorizontal")
        self.totalWidth = try object.value(for: "totalWidth")
        self.rowHeightMultiplication = try object.value(for: "rowHeightMultiplication")
        self.numberOfColumns = try object.value(for: "numberOfColumns")
        self.gutterHeight = try object.value(for: "gutterHeight")
        self.guttersOutside = try object.value(for: "guttersOutside")
        self.columnWidth = try object.value(for: "columnWidth")
    }

}

public class MSOvalShape: MSShapeLayer {

    public var booleanOperation: CGFloat
    public var edited: CGFloat
    public var path: MSShapePath

    public required init(object: MarshaledObject) throws {
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")

        try super.init(object: object)
    }

}

public class MSPage: NSObject, Unmarshaling {

    public var name: String
    public var verticalRulerData: MSRulerData
    public var resizingConstraint: CGFloat
    public var includeInCloudUpload: Bool
    public var objectID: String
    public var isVisible: Bool
    public var nameIsFixed: CGFloat
    public var style: MSStyle
    public var frame: MSRect
    public var layerListExpandedType: CGFloat
    public var rotation: CGFloat
    public var isFlippedVertical: Bool
    public var resizingType: CGFloat
    public var layers: [MSShapeLayer]
    public var isFlippedHorizontal: Bool
    public var shouldBreakMaskChain: Bool
    public var horizontalRulerData: MSRulerData
    public var exportOptions: MSExportOptions
    public var hasClickThrough: Bool
    public var isLocked: Bool

    public required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.verticalRulerData = try object.value(for: "verticalRulerData")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.includeInCloudUpload = try object.value(for: "includeInCloudUpload")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.style = try object.value(for: "style")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.rotation = try object.value(for: "rotation")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.layers = try object.value(for: "layers")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.horizontalRulerData = try object.value(for: "horizontalRulerData")
        self.exportOptions = try object.value(for: "exportOptions")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.isLocked = try object.value(for: "isLocked")
    }

}

public class MSPolygonShape: MSShapeLayer {

    public var numberOfPoints: CGFloat
    public var booleanOperation: CGFloat
    public var edited: CGFloat
    public var path: MSShapePath

    public required init(object: MarshaledObject) throws {
        self.numberOfPoints = try object.value(for: "numberOfPoints")
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")

        try super.init(object: object)
    }

}

public class MSRect: NSObject, Unmarshaling {

    public var height: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    public var constrainProportions: CGFloat
    public var width: CGFloat

    public required init(object: MarshaledObject) throws {
        self.height = try object.value(for: "height")
        self.x = try object.value(for: "x")
        self.y = try object.value(for: "y")
        self.constrainProportions = try object.value(for: "constrainProportions")
        self.width = try object.value(for: "width")
    }

}

public class MSRectangleShape: MSShapeLayer {

    public var fixedRadius: CGFloat
    public var hasConvertedToNewRoundCorners: Bool
    public var edited: CGFloat
    public var path: MSShapePath
    public var booleanOperation: CGFloat

    public required init(object: MarshaledObject) throws {
        self.fixedRadius = try object.value(for: "fixedRadius")
        self.hasConvertedToNewRoundCorners = try object.value(for: "hasConvertedToNewRoundCorners")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")
        self.booleanOperation = try object.value(for: "booleanOperation")

        try super.init(object: object)
    }

}

public class MSRulerData: NSObject, Unmarshaling {

    public var guides: [SketchUnknown]
    public var base: CGFloat

    public required init(object: MarshaledObject) throws {
        self.guides = try object.value(for: "guides")
        self.base = try object.value(for: "base")
    }

}

public class MSShapeGroup: MSShapeLayer {

    public var clippingMaskMode: CGFloat
    public var style: MSStyle
    public var layers: [MSShapeLayer]
    public var windingRule: CGFloat
    public var hasClippingMask: Bool
    public var hasClickThrough: Bool

    public required init(object: MarshaledObject) throws {
        self.clippingMaskMode = try object.value(for: "clippingMaskMode")
        self.style = try object.value(for: "style")
        self.layers = try object.value(for: "layers")
        self.windingRule = try object.value(for: "windingRule")
        self.hasClippingMask = try object.value(for: "hasClippingMask")
        self.hasClickThrough = try object.value(for: "hasClickThrough")

        try super.init(object: object)
    }

}

public class MSShapeLayer: NSObject, ValueType {

    public var resizingConstraint: CGFloat
    public var nameIsFixed: CGFloat
    public var isVisible: Bool
    public var rotation: CGFloat
    public var isFlippedHorizontal: Bool
    public var objectID: String
    public var frame: MSRect
    public var layerListExpandedType: CGFloat
    public var resizingType: CGFloat
    public var shouldBreakMaskChain: Bool
    public var exportOptions: MSExportOptions
    public var isLocked: Bool
    public var name: String
    public var isFlippedVertical: Bool

    public required init(object: MarshaledObject) throws {
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.isVisible = try object.value(for: "isVisible")
        self.rotation = try object.value(for: "rotation")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.objectID = try object.value(for: "objectID")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.resizingType = try object.value(for: "resizingType")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.exportOptions = try object.value(for: "exportOptions")
        self.isLocked = try object.value(for: "isLocked")
        self.name = try object.value(for: "name")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
    }

    public static func value(from object: Any) throws -> Value {
        guard let obj = object as? [String: Any] else {
            throw MarshalError.typeMismatch(expected: [String:Any].self, actual: type(of: object))
        }
        guard let classKey = obj["<class>"] as? String else {
            throw MarshalError.nullValue(key: "<class>")
        }
        switch classKey {
        case "MSShapeLayer":
            return try MSShapeLayer(object: obj)
        case "MSOvalShape":
            return try MSOvalShape(object: obj)
        case "MSStarShape":
            return try MSStarShape(object: obj)
        case "MSTriangleShape":
            return try MSTriangleShape(object: obj)
        case "MSArtboardGroup":
            return try MSArtboardGroup(object: obj)
        case "MSSliceLayer":
            return try MSSliceLayer(object: obj)
        case "MSTextLayer":
            return try MSTextLayer(object: obj)
        case "MSShapePathLayer":
            return try MSShapePathLayer(object: obj)
        case "MSShapeGroup":
            return try MSShapeGroup(object: obj)
        case "MSRectangleShape":
            return try MSRectangleShape(object: obj)
        case "MSBitmapLayer":
            return try MSBitmapLayer(object: obj)
        case "MSSymbolMaster":
            return try MSSymbolMaster(object: obj)
        case "MSLayerGroup":
            return try MSLayerGroup(object: obj)
        case "MSSymbolInstance":
            return try MSSymbolInstance(object: obj)
        case "MSPolygonShape":
            return try MSPolygonShape(object: obj)
        default:
            throw MarshalError.keyNotFound(key: classKey)
        }
    }
    public var oval: MSOvalShape? {
        return self as? MSOvalShape
    }

    public var star: MSStarShape? {
        return self as? MSStarShape
    }

    public var triangle: MSTriangleShape? {
        return self as? MSTriangleShape
    }

    public var artboardGroup: MSArtboardGroup? {
        return self as? MSArtboardGroup
    }

    public var slice: MSSliceLayer? {
        return self as? MSSliceLayer
    }

    public var text: MSTextLayer? {
        return self as? MSTextLayer
    }

    public var shapePath: MSShapePathLayer? {
        return self as? MSShapePathLayer
    }

    public var shapeGroup: MSShapeGroup? {
        return self as? MSShapeGroup
    }

    public var rectangle: MSRectangleShape? {
        return self as? MSRectangleShape
    }

    public var bitmap: MSBitmapLayer? {
        return self as? MSBitmapLayer
    }

    public var symbolMaster: MSSymbolMaster? {
        return self as? MSSymbolMaster
    }

    public var layerGroup: MSLayerGroup? {
        return self as? MSLayerGroup
    }

    public var symbolInstance: MSSymbolInstance? {
        return self as? MSSymbolInstance
    }

    public var polygon: MSPolygonShape? {
        return self as? MSPolygonShape
    }

}

public class MSShapePath: NSObject, Unmarshaling {

    public var pointRadiusBehaviour: CGFloat
    public var isClosed: Bool
    public var points: [MSCurvePoint]

    public required init(object: MarshaledObject) throws {
        self.pointRadiusBehaviour = try object.value(for: "pointRadiusBehaviour")
        self.isClosed = try object.value(for: "isClosed")
        self.points = try object.value(for: "points")
    }

}

public class MSShapePathLayer: MSShapeLayer {

    public var booleanOperation: CGFloat
    public var edited: CGFloat
    public var path: MSShapePath

    public required init(object: MarshaledObject) throws {
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")

        try super.init(object: object)
    }

}

public class MSSharedStyle: NSObject, Unmarshaling {

    public var name: String
    public var value: MSStyle
    public var objectID: String

    public required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.value = try object.value(for: "value")
        self.objectID = try object.value(for: "objectID")
    }

}

public class MSSharedStyleContainer: NSObject, Unmarshaling {

    public var objects: [SketchUnknown]

    public required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }

}

public class MSSharedTextStyleContainer: NSObject, Unmarshaling {

    public var objects: [MSSharedStyle]

    public required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }

}

public class MSSimpleGrid: NSObject, Unmarshaling {

    public var thickGridTimes: CGFloat
    public var gridSize: CGFloat
    public var isEnabled: Bool

    public required init(object: MarshaledObject) throws {
        self.thickGridTimes = try object.value(for: "thickGridTimes")
        self.gridSize = try object.value(for: "gridSize")
        self.isEnabled = try object.value(for: "isEnabled")
    }

}

public class MSSliceLayer: MSShapeLayer {

    public var backgroundColor: MSColor
    public var hasBackgroundColor: Bool

    public required init(object: MarshaledObject) throws {
        self.backgroundColor = try object.value(for: "backgroundColor")
        self.hasBackgroundColor = try object.value(for: "hasBackgroundColor")

        try super.init(object: object)
    }

}

public class MSStarShape: MSShapeLayer {

    public var numberOfPoints: CGFloat
    public var booleanOperation: CGFloat
    public var edited: CGFloat
    public var path: MSShapePath
    public var radius: CGFloat

    public required init(object: MarshaledObject) throws {
        self.numberOfPoints = try object.value(for: "numberOfPoints")
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")
        self.radius = try object.value(for: "radius")

        try super.init(object: object)
    }

}

public class MSStyle: NSObject, Unmarshaling {

    public var textStyle: MSTextStyle?
    public var shadows: [MSStyleShadow]
    public var reflection: MSStyleReflection
    public var fills: [MSStyleFill]
    public var miterLimit: CGFloat
    public var startDecorationType: CGFloat
    public var borderOptions: MSStyleBorderOptions
    public var innerShadows: [MSStyleInnerShadow]
    public var contextSettings: MSGraphicsContextSettings
    public var endDecorationType: CGFloat
    public var sharedObjectID: String?
    public var borders: [MSStyleBorder]
    public var colorControls: MSStyleColorControls
    public var blur: MSStyleBlur

    public required init(object: MarshaledObject) throws {
        self.textStyle = try object.value(for: "textStyle")
        self.shadows = try object.value(for: "shadows")
        self.reflection = try object.value(for: "reflection")
        self.fills = try object.value(for: "fills")
        self.miterLimit = try object.value(for: "miterLimit")
        self.startDecorationType = try object.value(for: "startDecorationType")
        self.borderOptions = try object.value(for: "borderOptions")
        self.innerShadows = try object.value(for: "innerShadows")
        self.contextSettings = try object.value(for: "contextSettings")
        self.endDecorationType = try object.value(for: "endDecorationType")
        self.sharedObjectID = try object.value(for: "sharedObjectID")
        self.borders = try object.value(for: "borders")
        self.colorControls = try object.value(for: "colorControls")
        self.blur = try object.value(for: "blur")
    }

}

public class MSStyleBlur: NSObject, Unmarshaling {

    public var isEnabled: Bool
    public var center: CGPoint
    public var radius: CGFloat
    public var type: CGFloat
    public var motionAngle: CGFloat

    public required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.center = try object.value(for: "center")
        self.radius = try object.value(for: "radius")
        self.type = try object.value(for: "type")
        self.motionAngle = try object.value(for: "motionAngle")
    }

}

public class MSStyleBorder: NSObject, Unmarshaling {

    public var position: CGFloat
    public var isEnabled: Bool
    public var gradient: MSGradient
    public var fillType: CGFloat
    public var thickness: CGFloat
    public var contextSettings: MSGraphicsContextSettings
    public var color: MSColor

    public required init(object: MarshaledObject) throws {
        self.position = try object.value(for: "position")
        self.isEnabled = try object.value(for: "isEnabled")
        self.gradient = try object.value(for: "gradient")
        self.fillType = try object.value(for: "fillType")
        self.thickness = try object.value(for: "thickness")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
    }

}

public class MSStyleBorderOptions: NSObject, Unmarshaling {

    public var lineCapStyle: CGFloat
    public var dashPattern: [CGFloat]
    public var lineJoinStyle: CGFloat
    public var isEnabled: Bool

    public required init(object: MarshaledObject) throws {
        self.lineCapStyle = try object.value(for: "lineCapStyle")
        self.dashPattern = try object.value(for: "dashPattern")
        self.lineJoinStyle = try object.value(for: "lineJoinStyle")
        self.isEnabled = try object.value(for: "isEnabled")
    }

}

public class MSStyleColorControls: NSObject, Unmarshaling {

    public var contrast: CGFloat
    public var saturation: CGFloat
    public var hue: CGFloat
    public var brightness: CGFloat
    public var isEnabled: Bool

    public required init(object: MarshaledObject) throws {
        self.contrast = try object.value(for: "contrast")
        self.saturation = try object.value(for: "saturation")
        self.hue = try object.value(for: "hue")
        self.brightness = try object.value(for: "brightness")
        self.isEnabled = try object.value(for: "isEnabled")
    }

}

public class MSStyleFill: NSObject, Unmarshaling {

    public var isEnabled: Bool
    public var gradient: MSGradient
    public var image: MSImageData?
    public var fillType: CGFloat
    public var noiseIntensity: CGFloat
    public var noiseIndex: CGFloat
    public var patternFillType: CGFloat
    public var patternTileScale: CGFloat
    public var contextSettings: MSGraphicsContextSettings
    public var color: MSColor

    public required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.gradient = try object.value(for: "gradient")
        self.image = try object.value(for: "image")
        self.fillType = try object.value(for: "fillType")
        self.noiseIntensity = try object.value(for: "noiseIntensity")
        self.noiseIndex = try object.value(for: "noiseIndex")
        self.patternFillType = try object.value(for: "patternFillType")
        self.patternTileScale = try object.value(for: "patternTileScale")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
    }

}

public class MSStyleInnerShadow: NSObject, Unmarshaling {

    public var isEnabled: Bool
    public var offsetY: CGFloat
    public var blurRadius: CGFloat
    public var offsetX: CGFloat
    public var spread: CGFloat
    public var contextSettings: MSGraphicsContextSettings
    public var color: MSColor

    public required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.offsetY = try object.value(for: "offsetY")
        self.blurRadius = try object.value(for: "blurRadius")
        self.offsetX = try object.value(for: "offsetX")
        self.spread = try object.value(for: "spread")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
    }

}

public class MSStyleReflection: NSObject, Unmarshaling {

    public var distance: CGFloat
    public var strength: CGFloat
    public var isEnabled: Bool

    public required init(object: MarshaledObject) throws {
        self.distance = try object.value(for: "distance")
        self.strength = try object.value(for: "strength")
        self.isEnabled = try object.value(for: "isEnabled")
    }

}

public class MSStyleShadow: NSObject, Unmarshaling {

    public var isEnabled: Bool
    public var offsetY: CGFloat
    public var blurRadius: CGFloat
    public var offsetX: CGFloat
    public var spread: CGFloat
    public var contextSettings: MSGraphicsContextSettings
    public var color: MSColor

    public required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.offsetY = try object.value(for: "offsetY")
        self.blurRadius = try object.value(for: "blurRadius")
        self.offsetX = try object.value(for: "offsetX")
        self.spread = try object.value(for: "spread")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
    }

}

public class MSSymbolContainer: NSObject, Unmarshaling {

    public var objects: [SketchUnknown]

    public required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }

}

public class MSSymbolInstance: MSShapeLayer {

    public var symbolID: String
    public var masterInfluenceEdgeMinXPadding: CGFloat
    public var masterInfluenceEdgeMinYPadding: CGFloat
    public var verticalSpacing: CGFloat
    public var style: MSStyle
    public var horizontalSpacing: CGFloat
    public var masterInfluenceEdgeMaxXPadding: CGFloat
    public var masterInfluenceEdgeMaxYPadding: CGFloat

    public required init(object: MarshaledObject) throws {
        self.symbolID = try object.value(for: "symbolID")
        self.masterInfluenceEdgeMinXPadding = try object.value(for: "masterInfluenceEdgeMinXPadding")
        self.masterInfluenceEdgeMinYPadding = try object.value(for: "masterInfluenceEdgeMinYPadding")
        self.verticalSpacing = try object.value(for: "verticalSpacing")
        self.style = try object.value(for: "style")
        self.horizontalSpacing = try object.value(for: "horizontalSpacing")
        self.masterInfluenceEdgeMaxXPadding = try object.value(for: "masterInfluenceEdgeMaxXPadding")
        self.masterInfluenceEdgeMaxYPadding = try object.value(for: "masterInfluenceEdgeMaxYPadding")

        try super.init(object: object)
    }

}

public class MSSymbolMaster: MSShapeLayer {

    public var resizesContent: CGFloat
    public var includeInCloudUpload: Bool
    public var backgroundColor: MSColor
    public var style: MSStyle
    public var layers: [MSShapeLayer]
    public var horizontalRulerData: MSRulerData
    public var hasBackgroundColor: Bool
    public var includeBackgroundColorInExport: Bool
    public var symbolID: String
    public var verticalRulerData: MSRulerData
    public var includeBackgroundColorInInstance: Bool
    public var hasClickThrough: Bool

    public required init(object: MarshaledObject) throws {
        self.resizesContent = try object.value(for: "resizesContent")
        self.includeInCloudUpload = try object.value(for: "includeInCloudUpload")
        self.backgroundColor = try object.value(for: "backgroundColor")
        self.style = try object.value(for: "style")
        self.layers = try object.value(for: "layers")
        self.horizontalRulerData = try object.value(for: "horizontalRulerData")
        self.hasBackgroundColor = try object.value(for: "hasBackgroundColor")
        self.includeBackgroundColorInExport = try object.value(for: "includeBackgroundColorInExport")
        self.symbolID = try object.value(for: "symbolID")
        self.verticalRulerData = try object.value(for: "verticalRulerData")
        self.includeBackgroundColorInInstance = try object.value(for: "includeBackgroundColorInInstance")
        self.hasClickThrough = try object.value(for: "hasClickThrough")

        try super.init(object: object)
    }

}

public class MSTextLayer: MSShapeLayer {

    public var style: MSStyle
    public var dontSynchroniseWithSymbol: CGFloat
    public var glyphBounds: CGPoint
    public var attributedString: NSAttributedString
    public var automaticallyDrawOnUnderlyingPath: CGFloat
    public var lineSpacingBehaviour: CGFloat
    public var textBehaviour: CGFloat
    public var heightIsClipped: CGFloat

    public required init(object: MarshaledObject) throws {
        self.style = try object.value(for: "style")
        self.dontSynchroniseWithSymbol = try object.value(for: "dontSynchroniseWithSymbol")
        self.glyphBounds = try object.value(for: "glyphBounds")
        self.attributedString = try object.value(for: "attributedString")
        self.automaticallyDrawOnUnderlyingPath = try object.value(for: "automaticallyDrawOnUnderlyingPath")
        self.lineSpacingBehaviour = try object.value(for: "lineSpacingBehaviour")
        self.textBehaviour = try object.value(for: "textBehaviour")
        self.heightIsClipped = try object.value(for: "heightIsClipped")

        try super.init(object: object)
    }

}

public class MSTextStyle: NSObject, Unmarshaling {

    public var color: NSColor?
    public var font: NSFont?
    public var paragraphStyle: NSParagraphStyle?
    public var NSLigature: CGFloat?
    public var MSAttributedStringTextTransformAttribute: CGFloat?
    public var NSStrikethrough: CGFloat?
    public var NSUnderline: CGFloat?
    public var NSKern: CGFloat?
    public var NSSuperScript: CGFloat?

    public required init(object: MarshaledObject) throws {
        self.color = try object.value(for: "NSColor")
        self.font = try object.value(for: "NSFont")
        self.paragraphStyle = try object.value(for: "NSParagraphStyle")
        self.NSLigature = try object.value(for: "NSLigature")
        self.MSAttributedStringTextTransformAttribute = try object.value(for: "MSAttributedStringTextTransformAttribute")
        self.NSStrikethrough = try object.value(for: "NSStrikethrough")
        self.NSUnderline = try object.value(for: "NSUnderline")
        self.NSKern = try object.value(for: "NSKern")
        self.NSSuperScript = try object.value(for: "NSSuperScript")
    }
    
}

public class MSTriangleShape: MSShapeLayer {
    
    public var booleanOperation: CGFloat
    public var edited: CGFloat
    public var path: MSShapePath
    public var isEquilateral: Bool
    
    public required init(object: MarshaledObject) throws {
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")
        self.isEquilateral = try object.value(for: "isEquilateral")
        
        try super.init(object: object)
    }
    
}
