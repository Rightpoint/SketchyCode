//
//  SKPStackViewProxy.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SketchyPlugin.h"

typedef NS_ENUM(NSUInteger, SKPStackViewAxis) {
    SKPStackViewAxisHorizontal = 0,
    SKPStackViewAxisVertical
};

typedef NS_ENUM(NSUInteger, SKPStackViewAlignment) {
    SKPStackViewAlignmentFill = 0,
    SKPStackViewAlignmentLeading,
    SKPStackViewAlignmentFirstBaseline,
    SKPStackViewAlignmentCenter,
    SKPStackViewAlignmentTrailing,
    SKPStackViewAlignmentLastBaseline
};

typedef NS_ENUM(NSUInteger, SKPStackViewDistribution) {
    SKPStackViewDistributionFill = 0,
    SKPStackViewDistributionFillEqually,
    SKPStackViewDistributionFillProportionally,
    SKPStackViewDistributionEqualSpacing,
    SKPStackViewDistributionEqualCentering
};

@interface SKPStackViewProxy : NSObject

@property (strong, nonatomic, readonly) id<MSLayerGroupInterface> proxiedLayer;

@property (assign, nonatomic) SKPStackViewAxis axis;
@property (assign, nonatomic) SKPStackViewAlignment alignment;
@property (assign, nonatomic) SKPStackViewDistribution distribution;
@property (assign, nonatomic) CGFloat spacing;

+ (BOOL)layerContainsStackConfiguration:(id<MSLayerGroupInterface>)layer;

- (instancetype)initProxying:(id<MSLayerGroupInterface>)layer;

- (void)stopProxying;

@end
