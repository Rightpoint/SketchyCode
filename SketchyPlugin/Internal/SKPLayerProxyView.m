//
//  SKPLayerProxyView.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPLayerProxyView.h"
#import "SKPLayerObserver.h"

@interface SKPLayerProxyView() <SKPLayerObserver>

@property (assign, nonatomic) CGSize layerDefinedSize;
@property (assign, nonatomic) BOOL performingLayout;

@end

@implementation SKPLayerProxyView

- (instancetype)initProxying:(id<MSLayerInterface>)layer {
    if ( (self = [super init]) ) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [self setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [self setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

        [self setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
        [self setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

        self.proxiedLayer = layer;
    }
    return self;
}

- (void)dealloc {
    [(id)self.proxiedLayer skp_removeLayerObserver:self];
}

- (void)setProxiedLayer:(id<MSLayerInterface>)proxiedLayer {
    [(id)_proxiedLayer skp_removeLayerObserver:self];
    _proxiedLayer = proxiedLayer;
    [(id)_proxiedLayer skp_addLayerObserver:self];

    self.layerDefinedSize = proxiedLayer.rect.size;

    [self invalidateIntrinsicContentSize];
}

- (NSSize)intrinsicContentSize {
    return self.layerDefinedSize;
}

- (void)layout {
    self.performingLayout = YES;

    [super layout];
    self.proxiedLayer.rect = CGRectIntegral(self.frame);

    self.performingLayout = NO;
}

#pragma mark - SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property inLayer:(id<MSLayerInterface>)layer {
    // Prevent recursion
    if ( self.performingLayout ) {
        return;
    }

    if ( layer == self.proxiedLayer && [object isKindOfClass:NSClassFromString(@"MSRect")] ) {
        self.layerDefinedSize = layer.rect.size;
    }
}

#pragma mark - Private

- (void)setLayerDefinedSize:(CGSize)layerDefinedSize {
    _layerDefinedSize = layerDefinedSize;
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout:YES];
}

@end
