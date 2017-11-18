//
//  SKPStackProxy.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SketchyPlugin.h"

typedef NS_ENUM(NSUInteger, SKPStackAxis) {
    SKPStackAxisHorizontal = 0,
    SKPStackAxisVertical
};

typedef NS_ENUM(NSUInteger, SKPStackAlignment) {
    SKPStackAlignmentFill = 0,
    SKPStackAlignmentLeading,
    SKPStackAlignmentFirstBaseline,
    SKPStackAlignmentCenter,
    SKPStackAlignmentTrailing,
    SKPStackAlignmentLastBaseline
};

typedef NS_ENUM(NSUInteger, SKPStackDistribution) {
    SKPStackDistributionFill = 0,
    SKPStackDistributionFillEqually,
    SKPStackDistributionFillProportionally,
    SKPStackDistributionEqualSpacing,
    SKPStackDistributionEqualCentering
};

@interface SKPStackGroupProxy : NSObject

@property (strong, nonatomic, readonly) id<MSLayerGroupInterface> proxiedLayer;

@property (assign, nonatomic) SKPStackAxis axis;
@property (assign, nonatomic) SKPStackAlignment alignment;
@property (assign, nonatomic) SKPStackDistribution distribution;
@property (assign, nonatomic) CGFloat spacing;

+ (BOOL)layerHasBeenProxied:(id<MSLayerGroupInterface>)layer;
+ (SKPStackGroupProxy *)proxyForLayer:(id<MSLayerGroupInterface>)layer;

- (void)stopProxying;

@end
