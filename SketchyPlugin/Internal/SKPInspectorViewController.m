//
//  SKPInspectorViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.runtime;

#import "SKPInspectorViewController.h"
#import "SketchyPlugin.h"

@interface SKPInspectorViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;
@property (strong, nonatomic) IBOutlet NSView *namingView;
@property (strong, nonatomic) IBOutlet NSView *userDrivenView;

@end

@implementation SKPInspectorViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([SKPInspectorViewController class]) bundle:[NSBundle bundleForClass:[SKPInspectorViewController class]]];
}

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    NSMutableArray *views = [@[self.headerView, self.namingView] mutableCopy];

    if ( self.selectedLayersCanBeUserDriven ) {
        [views addObject:self.userDrivenView];
    }

    return views;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSArray *selectedLayers = [SketchInterface currentDocument].selectedLayers.layers;

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
    NSArray *selectedLayers = [SketchInterface currentDocument].selectedLayers.layers;

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

#pragma mark - Private

- (BOOL)selectedLayersCanBeUserDriven {
    NSArray *selectedLayers = [SketchInterface currentDocument].selectedLayers.layers;

    Class imageLayerClass = objc_getClass("MSBitmapLayer");
    Class textLayerClass = objc_getClass("MSTextLayer");

    for ( id layer in selectedLayers ) {
        if ( [layer class] != imageLayerClass && [layer class] != textLayerClass ) {
            return NO;
        }
    }

    return YES;
}

@end
