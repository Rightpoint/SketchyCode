//
//  SKPCodeGenViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.runtime;

#import "SKPCodeGenViewController.h"
#import "SketchyPlugin.h"

@interface SKPCodeGenViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;
@property (strong, nonatomic) IBOutlet NSView *namingView;
@property (strong, nonatomic) IBOutlet NSView *userDrivenView;

@end

@implementation SKPCodeGenViewController

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    NSMutableArray *views = [@[self.headerView, self.namingView] mutableCopy];

    if ( self.selectedLayersCanBeUserDriven ) {
        [views addObject:self.userDrivenView];
    }

    return views;
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
