//
//  SKPBaseInspectorViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/18/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPBaseInspectorViewController.h"
#import "SketchyPlugin.h"

@implementation SKPBaseInspectorViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

- (NSArray<NSView *> *)views {
    // Subclasses should override
    return nil;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSArray *selectedLayers = SketchInterface.selectedLayers;

    NSString *keyPath = [NSString stringWithFormat:@"userInfo.%@", key];
    NSArray *values = [selectedLayers valueForKeyPath:keyPath];

    BOOL multipleValues = NO;

    for ( NSUInteger i = 1; i < values.count; i++ ) {
        if ( ![values[i] isEqual:values[0]] ) {
            multipleValues = YES;
            break;
        }
    }

    if ( multipleValues ) {
        return @"(Mutliple Values)";
    }
    else if ( [[values firstObject] isEqual:[NSNull null]] ) {
        return nil;
    }
    else {
        return [values firstObject];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSArray *selectedLayers = SketchInterface.selectedLayers;

    for ( id<MSLayerInterface> layer in selectedLayers ) {
        NSMutableDictionary *userInfo = [layer.userInfo mutableCopy];
        if ( userInfo == nil ) {
            userInfo = [NSMutableDictionary dictionary];
        }

        if ( value == nil || ([value isKindOfClass:[NSString class]] && [value length] == 0) ) {
            [userInfo removeObjectForKey:key];
        }
        else {
            [userInfo setObject:value forKey:key];
        }

        layer.userInfo = userInfo;
    }
}

@end
