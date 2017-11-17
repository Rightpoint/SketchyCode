//
//  SKPStackViewProxy.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPStackViewProxy.h"

static NSString* const kSKPStackConfigurationKey = @"stackConfiguration";

@interface SKPStackViewProxy()

@property (strong, nonatomic, readonly) NSStackView *stackView;

@end

@implementation SKPStackViewProxy

+ (BOOL)layerContainsStackConfiguration:(id<MSLayerGroupInterface>)layer {
    return ([layer.userInfo objectForKey:kSKPStackConfigurationKey] != nil);
}

- (instancetype)initProxying:(id<MSLayerGroupInterface>)layer {
    if ( (self = [super init]) ) {
        _proxiedLayer = layer;
        _stackView = [[NSStackView alloc] init];

        [self importProperties:layer.userInfo[kSKPStackConfigurationKey]];
        [self applyProperties];
    }
    return self;
}

- (void)setAxis:(SKPStackViewAxis)axis {
    _axis = axis;
    [self applyProperties];
}

- (void)setAlignment:(SKPStackViewAlignment)alignment {
    _alignment = alignment;
    [self applyProperties];
}

- (void)setDistribution:(SKPStackViewDistribution)distribution {
    _distribution = distribution;
    [self applyProperties];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self applyProperties];
}

- (void)stopProxying {
    NSMutableDictionary *userInfo = [self.proxiedLayer.userInfo mutableCopy];
    [userInfo removeObjectForKey:kSKPStackConfigurationKey];
    self.proxiedLayer.userInfo = userInfo;

    _proxiedLayer = nil;
}

#pragma mark - Private

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

@end
