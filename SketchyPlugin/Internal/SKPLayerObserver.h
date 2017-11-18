//
//  SKPRectObserver.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SketchyPlugin.h"

@protocol SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property inLayer:(id<MSLayerInterface>)layer;

@end

@interface NSObject (SKPLayerObserver)

- (void)skp_addLayerObserver:(id<SKPLayerObserver>)observer;
- (void)skp_removeLayerObserver:(id<SKPLayerObserver>)observer;

@end
