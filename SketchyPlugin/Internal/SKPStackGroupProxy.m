//
//  SKPStackGroupProxy.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.runtime;

#import "SKPStackGroupProxy.h"
#import "SKPLayerObserver.h"
#import "SKPLayerProxyView.h"

static NSString* const kSKPStackConfigurationKey = @"stackConfiguration";

@interface SKPStackView : NSStackView
@end

@interface SKPStackGroupProxy() <SKPLayerObserver>

@property (strong, nonatomic, readonly) NSStackView *stackView;
@property (strong, nonatomic, readonly) NSMapTable *viewMap;

@property (assign, nonatomic) BOOL performingLayout;

@end

@implementation SKPStackGroupProxy

@synthesize viewMap = _viewMap;

+ (BOOL)layerHasBeenProxied:(id<MSLayerGroupInterface>)layer {
    return ([layer.userInfo objectForKey:kSKPStackConfigurationKey] != nil);
}

+ (SKPStackGroupProxy *)proxyForLayer:(id<MSLayerGroupInterface>)layer {
    NSMapTable *proxyMap = [self proxyMap];
    SKPStackGroupProxy *proxy = [proxyMap objectForKey:layer.objectID];

    if ( proxy == nil ) {
        proxy = [[self alloc] initProxying:layer];
        [proxyMap setObject:proxy forKey:layer.objectID];
    }

    return proxy;
}

- (void)setAxis:(SKPStackAxis)axis {
    _axis = axis;
    [self applyProperties];
}

- (void)setAlignment:(SKPStackAlignment)alignment {
    _alignment = alignment;
    [self applyProperties];
}

- (void)setDistribution:(SKPStackDistribution)distribution {
    _distribution = distribution;
    [self applyProperties];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self applyProperties];
}

- (void)stopProxying {
    [(id)self.proxiedLayer skp_removeLayerObserver:self];

    NSMutableDictionary *userInfo = [self.proxiedLayer.userInfo mutableCopy];
    [userInfo removeObjectForKey:kSKPStackConfigurationKey];
    self.proxiedLayer.userInfo = userInfo;

    [[[self class] proxyMap] removeObjectForKey:self.proxiedLayer.objectID];

    _proxiedLayer = nil;
}

#pragma mark - Private

+ (NSMapTable *)proxyMap {
    static NSMapTable *proxyMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxyMap = [NSMapTable strongToStrongObjectsMapTable];
    });
    return proxyMap;
}

- (instancetype)initProxying:(id<MSLayerGroupInterface>)layer {
    if ( (self = [super init]) ) {
        _proxiedLayer = layer;
        _stackView = [[SKPStackView alloc] init];

        // Changes in child layers bubble up to parents,
        // so adding an observer to the container will catch all changes in the group
        [(id)layer skp_addLayerObserver:self];

        [self rebuildViews];

        [self importProperties:layer.userInfo[kSKPStackConfigurationKey]];
        [self applyProperties];
    }
    return self;
}

- (NSMapTable *)viewMap {
    if ( _viewMap == nil ) {
        _viewMap = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _viewMap;
}

- (NSDictionary *)configurationDictionary {
    return @{ @"axis": @(self.axis),
              @"alignment": @(self.alignment),
              @"distribution": @(self.distribution),
              @"spacing": @(self.spacing) };
}

- (void)importProperties:(NSDictionary *)dict {
    if ( dict != nil ) {
        self.axis = [dict[@"axis"] integerValue];
        self.alignment = [dict[@"alignment"] integerValue];
        self.distribution = [dict[@"distribution"] integerValue];
        self.spacing = [dict[@"spacing"] doubleValue];
    }
}

- (void)applyProperties {
    self.stackView.orientation = (NSUserInterfaceLayoutOrientation)self.axis;
    self.stackView.distribution = (NSStackViewDistribution)self.distribution;
    self.stackView.spacing = self.spacing;

    NSMutableDictionary *userInfo = [self.proxiedLayer.userInfo ?: @{} mutableCopy];
    userInfo[kSKPStackConfigurationKey] = [self configurationDictionary];
    self.proxiedLayer.userInfo = userInfo;
}

- (void)rebuildViews {
    [self.viewMap removeAllObjects];
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Layers in sketch are rendered last child -> first child, which is opposite of AppKit
    for ( id layer in [self.proxiedLayer.layers reverseObjectEnumerator] ) {
        SKPLayerProxyView *proxyView = [[SKPLayerProxyView alloc] initProxying:layer];

        [self.viewMap setObject:proxyView forKey:layer];
        [self.stackView addArrangedSubview:proxyView];
    }
}

- (void)performLayout {
    self.performingLayout = YES;

    [self.proxiedLayer disableAutomaticScalingInBlock:^{
        [self.stackView setNeedsLayout:YES];
        [self.stackView layoutSubtreeIfNeeded];
        CGSize size = self.stackView.bounds.size;

        // For some reason, the setSize: setter doesn't notify delegate (confirmed in Hopper)
        // Instead, set dimensions individually to notify the delegate for redraw
        [self.proxiedLayer.frame setWidth:size.width];
        [self.proxiedLayer.frame setHeight:size.height];
    }];

    self.performingLayout = NO;
}

#pragma mark - SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property inLayer:(id<MSLayerInterface>)layer {
    // Prevent recursion
    if ( self.performingLayout ) {
        return;
    }

    if ( [property isEqualToString:@"layers"] ) {
        [self rebuildViews];
    }

    [self performLayout];
}

@end

#pragma mark - SKPStackView

@implementation SKPStackView

- (void)setNeedsLayout:(BOOL)needsLayout {
    for ( NSView *view in self.arrangedSubviews ) {
        [view setNeedsLayout:needsLayout];
    }
    [super setNeedsLayout:needsLayout];
}

@end
