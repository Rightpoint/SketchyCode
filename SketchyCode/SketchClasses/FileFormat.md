# File Format
This file contains notes on the sketch file format.

## MSShapeLayer
The Sketch layer hierarchy centers around MSShapeLayer. This base class has a handful of subclasses that are documented below. In addition to the generated classes, there are a few protocols to assist in using them:

- LayerContainer
- PathContainer
- Styled


## MSLayerGroup
MSLayerGroup is always unstyled, and can contain any number of layers. The MSLayerGroup is always unstyled, although it can be hidden and modify the alpha level.

## MSBitmapLayer

## MSTextLayer

## MSShapeGroup
An MSShapeGroup is created for every inserted shape. It also, will have a Sublayer that conforms to `PathContainer`. I believe the style present on this object is applied to the child layers.


## MSSymbolInstance
  This is a layer that is a reference to another layer. Need to investigate more

## MSRect
MSRect represents a frame. There is a `constrainProportions` that can be used to guide layout.

## MSStyle

MSStyle is an umbrella object for all other configuration. Off of MSStyle are a ton of properties
that are `Enableable`, many of which are present but disabled by default. These are the
properties of MSStyle.

- MSTextStyle
- MSStyleFill
- MSStyleShadow
- MSStyleInnerShadow
- MSStyleBorder / MSStyleBorderOptions
- MSStyleBlur
- MSStyleReflection
- MSGradient / MSGradientStop
- MSShapePath / MSCurvePoint
- MSImageData
- MSGraphcsContextSettings
- MSColor / NSColor / NSParagraphStyle / NSAttributedString

