//
//  SKPInspector.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.runtime;

#import "SKPInspector.h"
#import "SKPInspectorStackView.h"
#import "SKPMacros.h"

@implementation SKPInspector

- (instancetype)initWithRootView:(NSView *)rootView {
    if ( (self = [super init]) ) {
        _rootView = rootView;

        id content = self.inspectorController.normalInspector.stackView;

        if ( [content isKindOfClass:objc_getClass("MSInspectorStackView")] ) {
            object_setClass(content, [SKPInspectorStackView class]);
        }
        else {
            SKPLog("Inspector content type mistmatch. Expected MSInspectorStackView, found: %@", [content class]);
        }
    }
    return self;
}

- (id<MSInspectorControllerInterface>)inspectorController {
    return (id<MSInspectorControllerInterface>)[_rootView nextResponder];
}

@end
