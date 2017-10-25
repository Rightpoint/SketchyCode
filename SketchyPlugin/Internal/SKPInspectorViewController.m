//
//  SKPInspectorViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPInspectorViewController.h"
#import "SketchyPlugin.h"

@interface SKPInspectorViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;
@property (strong, nonatomic) IBOutlet NSView *namingView;

@end

@implementation SKPInspectorViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([SKPInspectorViewController class]) bundle:[NSBundle bundleForClass:[SKPInspectorViewController class]]];
}

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    return @[self.headerView, self.namingView];
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSArray *layers = [SketchInterface currentDocument].selectedLayers.layers;

    NSString *keyPath = [NSString stringWithFormat:@"userInfo.%@", key];
    return [[layers firstObject] valueForKeyPath:keyPath];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSArray<id<MSLayerInterface>> *layers = [SketchInterface currentDocument].selectedLayers.layers;

    for ( id<MSLayerInterface> layer in layers ) {
        NSMutableDictionary *userInfo = [layer.userInfo mutableCopy];
        if ( userInfo == nil ) {
            userInfo = [NSMutableDictionary dictionary];
        }

        userInfo[key] = value;
        layer.userInfo = userInfo;
    }
}

@end
