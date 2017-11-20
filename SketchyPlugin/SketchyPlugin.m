//
//  SketchyPlugin.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SketchyPlugin.h"
#import "SKPInspector.h"

@implementation SketchyPlugin

+ (void)reloadInspector {
    id<MSDocumentInterface> document = [SketchInterface currentDocument];
    SKPInspector *inspector = [[SKPInspector alloc] initWithRootView:document.splitViewController.inspectorView];

    [inspector.inspectorController reload];
}

+ (void)reloadLayerPosition {
    id<MSDocumentInterface> document = [SketchInterface currentDocument];
    SKPInspector *inspector = [[SKPInspector alloc] initWithRootView:document.splitViewController.inspectorView];

    [inspector.inspectorController layerPositionPossiblyChanged];
}

@end
