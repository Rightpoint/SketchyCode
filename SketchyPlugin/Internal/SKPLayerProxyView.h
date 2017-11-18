//
//  SKPLayerProxyView.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import AppKit;

#import "SketchyPlugin.h"

@interface SKPLayerProxyView : NSView

@property (weak, nonatomic) id<MSLayerInterface> proxiedLayer;

- (instancetype)initProxying:(id<MSLayerGroupInterface>)layer;

@end
