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

@property (strong, nonatomic, readonly) NSMutableArray *alignmentConstraints;

@property (assign, nonatomic) BOOL ignoreChangeEvents;

@end

@implementation SKPStackGroupProxy

@synthesize alignmentConstraints = _alignmentConstraints;

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

- (NSMutableArray *)alignmentConstraints {
    if ( _alignmentConstraints == nil ) {
        _alignmentConstraints = [NSMutableArray array];
    }
    return _alignmentConstraints;
}

- (NSDictionary *)configurationDictionary {
    return @{ @"axis": @(self.axis),
              @"alignment": @(self.alignment),
              @"distribution": @(self.distribution),
              @"spacing": @(self.spacing) };
}

- (void)importProperties:(NSDictionary *)dict {
    if ( dict != nil ) {
        _axis = [dict[@"axis"] integerValue];
        _alignment = [dict[@"alignment"] integerValue];
        _distribution = [dict[@"distribution"] integerValue];
        _spacing = [dict[@"spacing"] doubleValue];
        [self applyProperties];
    }
}

- (void)applyProperties {
    self.stackView.orientation = (NSUserInterfaceLayoutOrientation)self.axis;
    self.stackView.distribution = (NSStackViewDistribution)self.distribution;
    self.stackView.spacing = self.spacing;

    switch ( self.alignment ) {
        case SKPStackAlignmentFill:
        case SKPStackAlignmentCenter:
            self.stackView.alignment = (self.axis) == SKPStackAxisHorizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
            break;

        case SKPStackAlignmentLeading:
            self.stackView.alignment = (self.axis) == SKPStackAxisHorizontal ? NSLayoutAttributeBottom : NSLayoutAttributeLeading;
            break;

        case SKPStackAlignmentTrailing:
            self.stackView.alignment = (self.axis) == SKPStackAxisHorizontal ? NSLayoutAttributeTop : NSLayoutAttributeTrailing;
            break;
    }

    [self updateAlignmentConstraints];

    NSMutableDictionary *userInfo = [self.proxiedLayer.userInfo ?: @{} mutableCopy];
    userInfo[kSKPStackConfigurationKey] = [self configurationDictionary];
    self.proxiedLayer.userInfo = userInfo;
}

- (void)rebuildViews {
    self.ignoreChangeEvents = YES;

    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Layers in sketch are rendered last child -> first child, which is opposite of AppKit
    for ( id<MSLayerInterface> layer in [self.proxiedLayer.layers reverseObjectEnumerator] ) {
        // Don't let Sketch resize children automatically when resizing the group
        // (this will be managed by the stack view layout)
        [layer setResizingConstraint:SKPLayerResizingConstraintFixedDimensions];

        SKPLayerProxyView *proxyView = [[SKPLayerProxyView alloc] initProxying:layer];
        [self.stackView addArrangedSubview:proxyView];
    }

    [self updateAlignmentConstraints];

    self.ignoreChangeEvents = NO;
}

- (void)updateAlignmentConstraints {
    [NSLayoutConstraint deactivateConstraints:self.alignmentConstraints];
    [self.alignmentConstraints removeAllObjects];

    if ( self.alignment == SKPStackAlignmentFill ) {
        for ( NSView *view in self.stackView.arrangedSubviews ) {
            if ( self.axis == SKPStackAxisHorizontal ) {
                [self.alignmentConstraints addObject:[view.heightAnchor constraintEqualToAnchor:self.stackView.heightAnchor]];
            }
            else {
                [self.alignmentConstraints addObject:[view.widthAnchor constraintEqualToAnchor:self.stackView.widthAnchor]];
            }
        }
    }

    [NSLayoutConstraint activateConstraints:self.alignmentConstraints];
}

- (void)performLayout {
    self.ignoreChangeEvents = YES;

    [self.proxiedLayer disableAutomaticScalingInBlock:^{
        CGSize size = self.stackView.fittingSize;
        [self.stackView setFrameSize:size];

        [self.stackView layoutSubtreeIfNeeded];

        // For some reason, the setSize: setter doesn't notify delegate (confirmed in Hopper)
        // Instead, set dimensions individually to notify the delegate for redraw
        [self.proxiedLayer.frame setWidth:size.width];
        [self.proxiedLayer.frame setHeight:size.height];
    }];

    [SketchyPlugin reloadLayerPosition];

    self.ignoreChangeEvents = NO;
}

#pragma mark - SKPLayerObserver

- (void)object:(id)object didChangeProperty:(NSString *)property inLayer:(id<MSLayerInterface>)layer {
    // Prevent recursion
    if ( self.ignoreChangeEvents ) {
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
