// This file is generated automatically, DO NOT EDIT

import CoreGraphics
import AppKit
import Marshal

class MSArtboardGroup: Unmarshaling {
    
    var resizesContent: CGFloat
    var includeInCloudUpload: CGFloat
    var backgroundColor: MSColor
    var nameIsFixed: CGFloat
    var isVisible: Bool
    var resizingConstraint: CGFloat
    var style: MSStyle
    var rotation: CGFloat
    var layers: [MSSymbolInstance]
    var isFlippedHorizontal: Bool
    var horizontalRulerData: MSRulerData
    var hasBackgroundColor: Bool
    var includeBackgroundColorInExport: CGFloat
    var name: String
    var verticalRulerData: MSRulerData
    var objectID: String
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var shouldBreakMaskChain: Bool
    var exportOptions: MSExportOptions
    var hasClickThrough: Bool
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.resizesContent = try object.value(for: "resizesContent")
        self.includeInCloudUpload = try object.value(for: "includeInCloudUpload")
        self.backgroundColor = try object.value(for: "backgroundColor")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.isVisible = try object.value(for: "isVisible")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.style = try object.value(for: "style")
        self.rotation = try object.value(for: "rotation")
        self.layers = try object.value(for: "layers")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.horizontalRulerData = try object.value(for: "horizontalRulerData")
        self.hasBackgroundColor = try object.value(for: "hasBackgroundColor")
        self.includeBackgroundColorInExport = try object.value(for: "includeBackgroundColorInExport")
        self.name = try object.value(for: "name")
        self.verticalRulerData = try object.value(for: "verticalRulerData")
        self.objectID = try object.value(for: "objectID")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.exportOptions = try object.value(for: "exportOptions")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSAssetCollection: Unmarshaling {
    
    var gradients: [SketchUnknown]
    var colors: [SketchUnknown]
    var images: [SketchUnknown]
    var imageCollection: MSImageCollection
    
    required init(object: MarshaledObject) throws {
        self.gradients = try object.value(for: "gradients")
        self.colors = try object.value(for: "colors")
        self.images = try object.value(for: "images")
        self.imageCollection = try object.value(for: "imageCollection")
    }
}

class MSBitmapLayer: MSShapeLayer {
    
    var style: MSStyle
    var clippingMask: CGPoint
    var image: MSImageData
    var nineSliceScale: CGSize
    var fillReplacesImage: CGFloat
    var nineSliceCenterRect: CGPoint
    
    required init(object: MarshaledObject) throws {
        self.style = try object.value(for: "style")
        self.clippingMask = try object.value(for: "clippingMask")
        self.image = try object.value(for: "image")
        self.nineSliceScale = try object.value(for: "nineSliceScale")
        self.fillReplacesImage = try object.value(for: "fillReplacesImage")
        self.nineSliceCenterRect = try object.value(for: "nineSliceCenterRect")
        
        try super.init(object: object)
    }
}

class MSColor: Unmarshaling {
    
    var value: String
    
    required init(object: MarshaledObject) throws {
        self.value = try object.value(for: "value")
    }
}

class MSCurvePoint: Unmarshaling {
    
    var hasCurveTo: Bool
    var curveFrom: CGPoint
    var curveTo: CGPoint
    var curveMode: CGFloat
    var hasCurveFrom: Bool
    var cornerRadius: CGFloat
    var point: CGPoint
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.hasCurveTo = try object.value(for: "hasCurveTo")
        self.curveFrom = try object.value(for: "curveFrom")
        self.curveTo = try object.value(for: "curveTo")
        self.curveMode = try object.value(for: "curveMode")
        self.hasCurveFrom = try object.value(for: "hasCurveFrom")
        self.cornerRadius = try object.value(for: "cornerRadius")
        self.point = try object.value(for: "point")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSDocumentData: Unmarshaling {
    
    var foreignSymbols: [SketchUnknown]
    var layerStyles: MSSharedStyleContainer
    var objectID: String
    var currentPageIndex: CGFloat
    var enableLayerInteraction: CGFloat
    var layerSymbols: MSSymbolContainer
    var assets: MSAssetCollection
    var enableSliceInteraction: CGFloat
    var layerTextStyles: MSSharedTextStyleContainer
    var pages: [MSPage]
    
    required init(object: MarshaledObject) throws {
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

class MSExportFormat: Unmarshaling {
    
    var fileFormat: String
    var name: String
    var namingScheme: CGFloat
    var visibleScaleType: CGFloat
    var scale: CGFloat
    var absoluteSize: CGFloat
    
    required init(object: MarshaledObject) throws {
        self.fileFormat = try object.value(for: "fileFormat")
        self.name = try object.value(for: "name")
        self.namingScheme = try object.value(for: "namingScheme")
        self.visibleScaleType = try object.value(for: "visibleScaleType")
        self.scale = try object.value(for: "scale")
        self.absoluteSize = try object.value(for: "absoluteSize")
    }
}

class MSExportOptions: Unmarshaling {
    
    var layerOptions: CGFloat
    var exportFormats: [MSExportFormat]
    var includedLayerIds: [SketchUnknown]
    var shouldTrim: Bool
    
    required init(object: MarshaledObject) throws {
        self.layerOptions = try object.value(for: "layerOptions")
        self.exportFormats = try object.value(for: "exportFormats")
        self.includedLayerIds = try object.value(for: "includedLayerIds")
        self.shouldTrim = try object.value(for: "shouldTrim")
    }
}

class MSGradient: Unmarshaling {
    
    var gradientType: CGFloat
    var from: CGPoint
    var shouldSmoothenOpacity: Bool
    var stops: [MSGradientStop]
    var to: CGPoint
    var elipseLength: CGFloat
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.gradientType = try object.value(for: "gradientType")
        self.from = try object.value(for: "from")
        self.shouldSmoothenOpacity = try object.value(for: "shouldSmoothenOpacity")
        self.stops = try object.value(for: "stops")
        self.to = try object.value(for: "to")
        self.elipseLength = try object.value(for: "elipseLength")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSGradientStop: Unmarshaling {
    
    var color: MSColor
    var position: CGFloat
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.color = try object.value(for: "color")
        self.position = try object.value(for: "position")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSGraphicsContextSettings: Unmarshaling {
    
    var blendMode: CGFloat
    var opacity: CGFloat
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.blendMode = try object.value(for: "blendMode")
        self.opacity = try object.value(for: "opacity")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSImageCollection: Unmarshaling {
    
    var images: [SketchUnknown]
    
    required init(object: MarshaledObject) throws {
        self.images = try object.value(for: "images")
    }
}

class MSImageData: Unmarshaling {
    
    var size: String
    var sha1: String
    
    required init(object: MarshaledObject) throws {
        self.size = try object.value(for: "size")
        self.sha1 = try object.value(for: "sha1")
    }
}

class MSLayerGroup: Unmarshaling {
    
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var isVisible: Bool
    var objectID: String
    var style: MSStyle
    var frame: MSRect
    var isFlippedVertical: Bool
    var rotation: CGFloat
    var layers: [MSShapeLayer]
    var resizingType: CGFloat
    var layerListExpandedType: CGFloat
    var shouldBreakMaskChain: Bool
    var isFlippedHorizontal: Bool
    var originalObjectID: String
    var exportOptions: MSExportOptions
    var hasClickThrough: Bool
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.isVisible = try object.value(for: "isVisible")
        self.objectID = try object.value(for: "objectID")
        self.style = try object.value(for: "style")
        self.frame = try object.value(for: "frame")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.rotation = try object.value(for: "rotation")
        self.layers = try object.value(for: "layers")
        self.resizingType = try object.value(for: "resizingType")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.originalObjectID = try object.value(for: "originalObjectID")
        self.exportOptions = try object.value(for: "exportOptions")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSOvalShape: MSShapeLayer {
    
    var booleanOperation: CGFloat
    var edited: CGFloat
    var path: MSShapePath
    
    required init(object: MarshaledObject) throws {
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")
        
        try super.init(object: object)
    }
}

class MSPage: Unmarshaling {
    
    var name: String
    var verticalRulerData: MSRulerData
    var resizingConstraint: CGFloat
    var includeInCloudUpload: CGFloat
    var objectID: String
    var isVisible: Bool
    var nameIsFixed: CGFloat
    var style: MSStyle
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var rotation: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var layers: [MSArtboardGroup]
    var isFlippedHorizontal: Bool
    var shouldBreakMaskChain: Bool
    var horizontalRulerData: MSRulerData
    var exportOptions: MSExportOptions
    var hasClickThrough: Bool
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
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

class MSRect: Unmarshaling {
    
    var height: CGFloat
    var x: CGFloat
    var y: CGFloat
    var constrainProportions: CGFloat
    var width: CGFloat
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.height = try object.value(for: "height")
        self.x = try object.value(for: "x")
        self.y = try object.value(for: "y")
        self.constrainProportions = try object.value(for: "constrainProportions")
        self.width = try object.value(for: "width")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSRectangleShape: Unmarshaling {
    
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var isFlippedVertical: Bool
    var rotation: CGFloat
    var resizingType: CGFloat
    var fixedRadius: CGFloat
    var hasConvertedToNewRoundCorners: Bool
    var edited: CGFloat
    var isFlippedHorizontal: Bool
    var path: MSShapePath
    var shouldBreakMaskChain: Bool
    var booleanOperation: CGFloat
    var exportOptions: MSExportOptions
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.rotation = try object.value(for: "rotation")
        self.resizingType = try object.value(for: "resizingType")
        self.fixedRadius = try object.value(for: "fixedRadius")
        self.hasConvertedToNewRoundCorners = try object.value(for: "hasConvertedToNewRoundCorners")
        self.edited = try object.value(for: "edited")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.path = try object.value(for: "path")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.exportOptions = try object.value(for: "exportOptions")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSRulerData: Unmarshaling {
    
    var guides: [SketchUnknown]
    var base: CGFloat
    
    required init(object: MarshaledObject) throws {
        self.guides = try object.value(for: "guides")
        self.base = try object.value(for: "base")
    }
}

class MSShapeGroup: Unmarshaling {
    
    var clippingMaskMode: CGFloat
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var style: MSStyle
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var rotation: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var layers: [MSShapeLayer]
    var windingRule: CGFloat
    var isFlippedHorizontal: Bool
    var hasClippingMask: Bool
    var shouldBreakMaskChain: Bool
    var exportOptions: MSExportOptions
    var hasClickThrough: Bool
    var isLocked: Bool
    var originalObjectID: String
    
    required init(object: MarshaledObject) throws {
        self.clippingMaskMode = try object.value(for: "clippingMaskMode")
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.style = try object.value(for: "style")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.rotation = try object.value(for: "rotation")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.layers = try object.value(for: "layers")
        self.windingRule = try object.value(for: "windingRule")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.hasClippingMask = try object.value(for: "hasClippingMask")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.exportOptions = try object.value(for: "exportOptions")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.isLocked = try object.value(for: "isLocked")
        self.originalObjectID = try object.value(for: "originalObjectID")
    }
}

class MSShapeLayer: Unmarshaling {
    
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var rotation: CGFloat
    var shouldBreakMaskChain: Bool
    var isFlippedHorizontal: Bool
    var exportOptions: MSExportOptions
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.rotation = try object.value(for: "rotation")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.exportOptions = try object.value(for: "exportOptions")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSShapePath: Unmarshaling {
    
    var pointRadiusBehaviour: CGFloat
    var isClosed: Bool
    var points: [MSCurvePoint]
    
    required init(object: MarshaledObject) throws {
        self.pointRadiusBehaviour = try object.value(for: "pointRadiusBehaviour")
        self.isClosed = try object.value(for: "isClosed")
        self.points = try object.value(for: "points")
    }
}

class MSShapePathLayer: Unmarshaling {
    
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var frame: MSRect
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var rotation: CGFloat
    var layerListExpandedType: CGFloat
    var booleanOperation: CGFloat
    var shouldBreakMaskChain: Bool
    var edited: CGFloat
    var path: MSShapePath
    var isFlippedHorizontal: Bool
    var exportOptions: MSExportOptions
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.frame = try object.value(for: "frame")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.rotation = try object.value(for: "rotation")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.booleanOperation = try object.value(for: "booleanOperation")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.edited = try object.value(for: "edited")
        self.path = try object.value(for: "path")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.exportOptions = try object.value(for: "exportOptions")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSSharedStyle: Unmarshaling {
    
    var name: String
    var value: MSStyle
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.value = try object.value(for: "value")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSSharedStyleContainer: Unmarshaling {
    
    var objects: [MSSharedStyle]
    
    required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }
}

class MSSharedTextStyleContainer: Unmarshaling {
    
    var objects: [MSSharedStyle]
    
    required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }
}

class MSStyle: Unmarshaling {
    
    var fills: [MSStyleFill]
    var shadows: [MSStyleShadow]
    var reflection: MSStyleReflection
    var miterLimit: CGFloat
    var startDecorationType: CGFloat
    var borderOptions: MSStyleBorderOptions
    var innerShadows: [MSStyleInnerShadow]
    var contextSettings: MSGraphicsContextSettings
    var endDecorationType: CGFloat
    var sharedObjectID: String
    var borders: [MSStyleBorder]
    var colorControls: MSStyleColorControls
    var blur: MSStyleBlur
    var textStyle: MSTextStyle
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.fills = try object.value(for: "fills")
        self.shadows = try object.value(for: "shadows")
        self.reflection = try object.value(for: "reflection")
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
        self.textStyle = try object.value(for: "textStyle")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleBlur: Unmarshaling {
    
    var isEnabled: Bool
    var center: CGPoint
    var radius: CGFloat
    var type: CGFloat
    var motionAngle: CGFloat
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.center = try object.value(for: "center")
        self.radius = try object.value(for: "radius")
        self.type = try object.value(for: "type")
        self.motionAngle = try object.value(for: "motionAngle")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleBorder: Unmarshaling {
    
    var position: CGFloat
    var isEnabled: Bool
    var gradient: MSGradient
    var fillType: CGFloat
    var thickness: CGFloat
    var contextSettings: MSGraphicsContextSettings
    var color: MSColor
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.position = try object.value(for: "position")
        self.isEnabled = try object.value(for: "isEnabled")
        self.gradient = try object.value(for: "gradient")
        self.fillType = try object.value(for: "fillType")
        self.thickness = try object.value(for: "thickness")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleBorderOptions: Unmarshaling {
    
    var lineCapStyle: CGFloat
    var dashPattern: [SketchUnknown]
    var lineJoinStyle: CGFloat
    var isEnabled: Bool
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.lineCapStyle = try object.value(for: "lineCapStyle")
        self.dashPattern = try object.value(for: "dashPattern")
        self.lineJoinStyle = try object.value(for: "lineJoinStyle")
        self.isEnabled = try object.value(for: "isEnabled")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleColorControls: Unmarshaling {
    
    var contrast: CGFloat
    var saturation: CGFloat
    var hue: CGFloat
    var brightness: CGFloat
    var isEnabled: Bool
    
    required init(object: MarshaledObject) throws {
        self.contrast = try object.value(for: "contrast")
        self.saturation = try object.value(for: "saturation")
        self.hue = try object.value(for: "hue")
        self.brightness = try object.value(for: "brightness")
        self.isEnabled = try object.value(for: "isEnabled")
    }
}

class MSStyleFill: Unmarshaling {
    
    var color: MSColor
    var gradient: MSGradient
    var fillType: CGFloat
    var noiseIntensity: CGFloat
    var patternFillType: CGFloat
    var noiseIndex: CGFloat
    var patternTileScale: CGFloat
    var contextSettings: MSGraphicsContextSettings
    var isEnabled: Bool
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.color = try object.value(for: "color")
        self.gradient = try object.value(for: "gradient")
        self.fillType = try object.value(for: "fillType")
        self.noiseIntensity = try object.value(for: "noiseIntensity")
        self.patternFillType = try object.value(for: "patternFillType")
        self.noiseIndex = try object.value(for: "noiseIndex")
        self.patternTileScale = try object.value(for: "patternTileScale")
        self.contextSettings = try object.value(for: "contextSettings")
        self.isEnabled = try object.value(for: "isEnabled")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleInnerShadow: Unmarshaling {
    
    var isEnabled: Bool
    var offsetY: CGFloat
    var blurRadius: CGFloat
    var offsetX: CGFloat
    var spread: CGFloat
    var contextSettings: MSGraphicsContextSettings
    var color: MSColor
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.offsetY = try object.value(for: "offsetY")
        self.blurRadius = try object.value(for: "blurRadius")
        self.offsetX = try object.value(for: "offsetX")
        self.spread = try object.value(for: "spread")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSStyleReflection: Unmarshaling {
    
    var distance: CGFloat
    var strength: CGFloat
    var isEnabled: Bool
    
    required init(object: MarshaledObject) throws {
        self.distance = try object.value(for: "distance")
        self.strength = try object.value(for: "strength")
        self.isEnabled = try object.value(for: "isEnabled")
    }
}

class MSStyleShadow: Unmarshaling {
    
    var isEnabled: Bool
    var offsetY: CGFloat
    var blurRadius: CGFloat
    var offsetX: CGFloat
    var spread: CGFloat
    var contextSettings: MSGraphicsContextSettings
    var color: MSColor
    var objectID: String
    
    required init(object: MarshaledObject) throws {
        self.isEnabled = try object.value(for: "isEnabled")
        self.offsetY = try object.value(for: "offsetY")
        self.blurRadius = try object.value(for: "blurRadius")
        self.offsetX = try object.value(for: "offsetX")
        self.spread = try object.value(for: "spread")
        self.contextSettings = try object.value(for: "contextSettings")
        self.color = try object.value(for: "color")
        self.objectID = try object.value(for: "objectID")
    }
}

class MSSymbolContainer: Unmarshaling {
    
    var objects: [SketchUnknown]
    
    required init(object: MarshaledObject) throws {
        self.objects = try object.value(for: "objects")
    }
}

class MSSymbolInstance: Unmarshaling {
    
    var symbolID: String
    var name: String
    var masterInfluenceEdgeMinXPadding: CGFloat
    var overrides: [String: Any]
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var masterInfluenceEdgeMinYPadding: CGFloat
    var verticalSpacing: CGFloat
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var style: MSStyle
    var rotation: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var horizontalSpacing: CGFloat
    var isFlippedHorizontal: Bool
    var shouldBreakMaskChain: Bool
    var exportOptions: MSExportOptions
    var masterInfluenceEdgeMaxXPadding: CGFloat
    var isLocked: Bool
    var masterInfluenceEdgeMaxYPadding: CGFloat
    
    required init(object: MarshaledObject) throws {
        self.symbolID = try object.value(for: "symbolID")
        self.name = try object.value(for: "name")
        self.masterInfluenceEdgeMinXPadding = try object.value(for: "masterInfluenceEdgeMinXPadding")
        self.overrides = try object.value(for: "overrides")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.masterInfluenceEdgeMinYPadding = try object.value(for: "masterInfluenceEdgeMinYPadding")
        self.verticalSpacing = try object.value(for: "verticalSpacing")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.style = try object.value(for: "style")
        self.rotation = try object.value(for: "rotation")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.horizontalSpacing = try object.value(for: "horizontalSpacing")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.exportOptions = try object.value(for: "exportOptions")
        self.masterInfluenceEdgeMaxXPadding = try object.value(for: "masterInfluenceEdgeMaxXPadding")
        self.isLocked = try object.value(for: "isLocked")
        self.masterInfluenceEdgeMaxYPadding = try object.value(for: "masterInfluenceEdgeMaxYPadding")
    }
}

class MSSymbolMaster: Unmarshaling {
    
    var resizesContent: CGFloat
    var includeInCloudUpload: CGFloat
    var backgroundColor: MSColor
    var nameIsFixed: CGFloat
    var isVisible: Bool
    var resizingConstraint: CGFloat
    var style: MSStyle
    var rotation: CGFloat
    var layers: [MSShapeLayer]
    var isFlippedHorizontal: Bool
    var horizontalRulerData: MSRulerData
    var hasBackgroundColor: Bool
    var includeBackgroundColorInExport: CGFloat
    var symbolID: String
    var name: String
    var verticalRulerData: MSRulerData
    var objectID: String
    var includeBackgroundColorInInstance: CGFloat
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var shouldBreakMaskChain: Bool
    var exportOptions: MSExportOptions
    var hasClickThrough: Bool
    var isLocked: Bool
    
    required init(object: MarshaledObject) throws {
        self.resizesContent = try object.value(for: "resizesContent")
        self.includeInCloudUpload = try object.value(for: "includeInCloudUpload")
        self.backgroundColor = try object.value(for: "backgroundColor")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.isVisible = try object.value(for: "isVisible")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.style = try object.value(for: "style")
        self.rotation = try object.value(for: "rotation")
        self.layers = try object.value(for: "layers")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.horizontalRulerData = try object.value(for: "horizontalRulerData")
        self.hasBackgroundColor = try object.value(for: "hasBackgroundColor")
        self.includeBackgroundColorInExport = try object.value(for: "includeBackgroundColorInExport")
        self.symbolID = try object.value(for: "symbolID")
        self.name = try object.value(for: "name")
        self.verticalRulerData = try object.value(for: "verticalRulerData")
        self.objectID = try object.value(for: "objectID")
        self.includeBackgroundColorInInstance = try object.value(for: "includeBackgroundColorInInstance")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.exportOptions = try object.value(for: "exportOptions")
        self.hasClickThrough = try object.value(for: "hasClickThrough")
        self.isLocked = try object.value(for: "isLocked")
    }
}

class MSTextLayer: Unmarshaling {
    
    var name: String
    var resizingConstraint: CGFloat
    var nameIsFixed: CGFloat
    var objectID: String
    var isVisible: Bool
    var frame: MSRect
    var layerListExpandedType: CGFloat
    var style: MSStyle
    var rotation: CGFloat
    var isFlippedVertical: Bool
    var resizingType: CGFloat
    var dontSynchroniseWithSymbol: CGFloat
    var isFlippedHorizontal: Bool
    var glyphBounds: CGPoint
    var attributedString: NSAttributedString
    var shouldBreakMaskChain: Bool
    var originalObjectID: String
    var automaticallyDrawOnUnderlyingPath: CGFloat
    var exportOptions: MSExportOptions
    var lineSpacingBehaviour: CGFloat
    var textBehaviour: CGFloat
    var isLocked: Bool
    var heightIsClipped: CGFloat
    
    required init(object: MarshaledObject) throws {
        self.name = try object.value(for: "name")
        self.resizingConstraint = try object.value(for: "resizingConstraint")
        self.nameIsFixed = try object.value(for: "nameIsFixed")
        self.objectID = try object.value(for: "objectID")
        self.isVisible = try object.value(for: "isVisible")
        self.frame = try object.value(for: "frame")
        self.layerListExpandedType = try object.value(for: "layerListExpandedType")
        self.style = try object.value(for: "style")
        self.rotation = try object.value(for: "rotation")
        self.isFlippedVertical = try object.value(for: "isFlippedVertical")
        self.resizingType = try object.value(for: "resizingType")
        self.dontSynchroniseWithSymbol = try object.value(for: "dontSynchroniseWithSymbol")
        self.isFlippedHorizontal = try object.value(for: "isFlippedHorizontal")
        self.glyphBounds = try object.value(for: "glyphBounds")
        self.attributedString = try object.value(for: "attributedString")
        self.shouldBreakMaskChain = try object.value(for: "shouldBreakMaskChain")
        self.originalObjectID = try object.value(for: "originalObjectID")
        self.automaticallyDrawOnUnderlyingPath = try object.value(for: "automaticallyDrawOnUnderlyingPath")
        self.exportOptions = try object.value(for: "exportOptions")
        self.lineSpacingBehaviour = try object.value(for: "lineSpacingBehaviour")
        self.textBehaviour = try object.value(for: "textBehaviour")
        self.isLocked = try object.value(for: "isLocked")
        self.heightIsClipped = try object.value(for: "heightIsClipped")
    }
}

class MSTextStyle: Unmarshaling {
    
    var color: NSColor
    var NSKern: CGFloat
    var paragraphStyle: NSParagraphStyle
    var NSFont: NSFont
    
    required init(object: MarshaledObject) throws {
        self.color = try object.value(for: "color")
        self.NSKern = try object.value(for: "NSKern")
        self.paragraphStyle = try object.value(for: "paragraphStyle")
        self.NSFont = try object.value(for: "NSFont")
    }
}



