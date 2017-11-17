//
//  SKPRectObserver.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SketchyPlugin.h"

@protocol SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property;

@end

@interface NSObject (SKPLayerObserver)

@property (strong, nonatomic) id<SKPLayerObserver> skp_layerObserver;

@end
