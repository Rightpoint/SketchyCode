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

@property (nonatomic, readonly) id<MSInspectorControllerInterface> inspectorController;

- (instancetype)initWithRootView:(NSView *)rootView;

@end
