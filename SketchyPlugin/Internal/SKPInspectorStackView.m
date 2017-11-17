//
//  SKPInspectorStackView.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.message;

#import "SKPInspectorStackView.h"
#import "SKPCodeGenViewController.h"
#import "SKPStackOptionsViewController.h"
#import "NSArray+SKPExtensions.h"

@implementation SKPInspectorStackView

@dynamic sectionViewControllers;

+ (void)load {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    class_setSuperclass(self, objc_getClass("MSInspectorStackView"));
#pragma clang diagnostic pop
}

- (void)reloadWithViewControllers:(NSArray<NSViewController *> *)viewControllers {
    struct objc_super sup = {
        self,
        [self superclass]
    };

    NSMutableArray *vcs = [viewControllers mutableCopy];

    if ( [SketchInterface.currentDocument.selectedLayers.layers skp_areAllKindOfClass:objc_getClass("MSLayerGroup")] && ![viewControllers skp_containsKindOfClass:[SKPStackOptionsViewController class]] ) {
        [vcs addObject:[SKPStackOptionsViewController new]];
    }
    else {
        [vcs skp_removeKindsOfClass:[SKPStackOptionsViewController class]];
    }

    if ( ![viewControllers skp_containsKindOfClass:[SKPCodeGenViewController class]] ) {
        [vcs addObject:[SKPCodeGenViewController new]];
    }
    
    ((void (*)(struct objc_super*, SEL, id))objc_msgSendSuper)(&sup, _cmd, vcs);
}

@end
