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

@property (assign, nonatomic) BOOL performingLayout;

@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation SKPLayerProxyView

- (instancetype)initProxying:(id<MSLayerGroupInterface>)layer {
    if ( (self = [super init]) ) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.widthConstraint = [self.widthAnchor constraintEqualToConstant:0];
        self.widthConstraint.priority = NSLayoutPriorityDefaultHigh;
        self.widthConstraint.active = true;

        self.heightConstraint = [self.heightAnchor constraintEqualToConstant:0];
        self.heightConstraint.priority = NSLayoutPriorityDefaultHigh;
        self.heightConstraint.active = true;

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

    [self syncConstraints];
}

- (void)layout {
    self.performingLayout = YES;

    [super layout];
    self.proxiedLayer.rect = self.frame;

    self.performingLayout = NO;
}

#pragma mark - SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property inLayer:(id<MSLayerInterface>)layer {
    // Prevent recursion
    if ( self.performingLayout ) {
        return;
    }

    // Any number of property changes could affect the layer's frame,
    // so always update the layout as a shotgun approach
    [self setNeedsLayout:YES];
}

#pragma mark - Private

- (void)syncConstraints {
    CGSize layerSize = self.proxiedLayer.rect.size;

    self.widthConstraint.constant = layerSize.width;
    self.heightConstraint.constant = layerSize.height;
}

@end
