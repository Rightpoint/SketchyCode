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
    id<MSInspectorStackViewInterface> inspectorContent = inspector.contentStack;

    if ( inspectorContent == nil ) {
        SKPLog(@"Failed to inject SketchyPlugin interface: Inspector content stack not found.");
        return;
    }

    [inspectorContent reloadWithViewControllers:inspectorContent.sectionViewControllers];
}

@end
