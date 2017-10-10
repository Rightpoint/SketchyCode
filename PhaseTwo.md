# Phase Two

This document describes the next phase of SketchyCode, a code generator for Sketch. A code generator for Sketch is not an entirely novel idea. There have been some plugins to generate [Swift](https://github.com/freshOS/SketchToSwift), [PDF/SVG](https://github.com/kang-chen/sketch-export-generator/) code, and tools to generate [UIKit drawing](https://www.paintcodeapp.com/sketch) code. There's also a pretty impressive [Cross Platform](https://supernova.studio/) app builder tool. Still, all of these solutions have missed the target in terms of the generated code.

Sketchy Code breaks the problem up into a few phases:

## Sketch parsing
SketchyCode currently has preliminary support for loading Sketch files, although support is incomplete. SketchyCode scans an exhaustive Sketch file and uses this JSON to generate a set of model files that can load Sketch files and provide a type safe API for SketchyCode internally. This alone does not generate a nice developer API, but it provides good basic data modeling. It also provides a basic support for adapting to changes in the JSON format used by Sketch as the tool evolves.

## Intent
Interpreting a design is not easy. Sketch files do not model an app, they model the appearance of a screen. The behavior of a screen is managed accross multiple layers, pages and implied contracts between the designer and developer. For example, nothing in the design of a Slider enumerates the behavior of the slider. Additional examples include animations, selected state, loading indicators, error states, size classes and screen transitions. Also, each platform have their own interpretations that should be done to generate good implementations, like configuring UINavigationController or UITabBarController instead of generating a different view for the tab / navigation bar on each screen.

In short, a sketch file is an imperfect product definition. However Sketch should be able to be the source of truth for an app's appearance. The goal is to provide a specific, developer guided process to opt into code generation. This behavior will start as a layer-naming strategy, but a Sketch Plugin will follow. The process should be simple enough that a designer can follow the process using this Plugin.

## Code Generation

The final phase is code generation. Generating code that a developer wants to interface with is an opinionated and challenging proposition. Making the compiler happy is the first goal. After that, the code that is generated should provide a "good" development experience and accomidate any desired coding style. SketchyCode aims to provide a number of well reasoned default implementations, and a framework that allows developers to inject their opinion in how code should be generated.


# Development plan.

Development will implement these 3 items slightly out of order. The parsing is largely functional, but incomplete. The simplest possible interpretation of the file will be used initially, with a direct 1 to 1 mapping of layers to views. This will allow exercise of the code generator and ensure that quality code can be generated.


## Code Generation

Code generation is an interesting challenge. Using a template is the most common technique used by code generators. This approach is great when is is the last step in the code generation process and there is no ambiguitiy between the model and the generated code.

The goals of SketchyCode is a bit more challenging than this. An intermediary representation (IR) is used to represent the series of commands that will be performed to re-create the Screen's visual appearance. As a Sketch file is "interpreted", configuration expressions along with some hints are added to the IR. This graph is then transformed into a representation that suits the developers preference, and the code is generated from this tuned IR. By maintaining an abstraction over the configuration expressions, code can be re-arranged without requiring a new template for each one.

The following features are helping define the initial implementation:

- Generate Subclasses.
- Use inline closures to configure view properties
- Support DI for generated subclasses
  - Mark color, images or text as externally available and require those values to be passed in.
- Good variable names
- Add code to specific lifecycle methods
  - Build view hierarchy in init
  - Update layer frames in `layoutSubviews`
  - Alter class generation structure
    - For example, a `configureSubviews` and `configureLayout` method
- Generated classes should be customizable without editing via subclass, DI or extensions.

### DI
- Explain how variables that are not assigned can be exposed to the containing method.

### Variable Naming
- Explain how variable naming is defered until code generation to allow expression mobility, infering the variable name and implicit self rules with the enclosing scope.

### State Extraction
Part of generating good view code is to represent multiple view states. The most straight forward example of this concept is defining the selected state of a cell or button. However, this approach is also a great strategy to encapsulate common states like loading and error states, as well as domain specific states like 'Admin User' vs 'Normal User', or different appearances for course dificulty.

SketchyCode aims to support this by tagging different layer hierarchies as representing different states of the UI. The complete IR will be generated for all of these layers. Then the IR that is shared between all of these states will be used to generate the basic class, then the configuration that is unique to each state will be managed by a `configureState` method.

## Sketch File Format
The Sketch document models a view hierarchy via the `MSShapeLayer` class hierarchy.

- MSShapeLayer
  - MSBitmapLayer -> UIImageView
  - MSLayerGroup -> 
  - MSOvalShape
  - MSRectangleShape
  - MSShapeGroup
  - MSShapePathLayer 
  - MSTextLayer -> UILabel | UITextField | UITextView
  - MSSymbolInstance

In addition to the view hierarchy, Sketch also has a handful of decoration objects that are attached in a various fashion to the layer types above.

- MSStyle
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


This doesn't map perfectly to the UIView heirarchy in a number of places. The initial release will focus on layout, solid colors and text configuration.
