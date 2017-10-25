//
//  SKPInspector.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import AppKit;

#import "SketchyPlugin.h"

@interface SKPInspector : NSObject

@property (nonatomic, readonly) NSView *rootView;

@property (nonatomic, readonly) NSStackView *containerStack;
@property (nonatomic, readonly) id<MSInspectorStackViewInterface> contentStack;

- (instancetype)initWithRootView:(NSView *)rootView;

@end
