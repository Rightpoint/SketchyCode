//
//  SKPInspectorStackView.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.message;

#import "SKPInspectorStackView.h"
#import "SKPInspectorViewController.h"

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

    if ( ![[viewControllers lastObject] isKindOfClass:[SKPInspectorViewController class]] ) {
        viewControllers = [viewControllers arrayByAddingObject:[SKPInspectorViewController new]];
    }
    
    ((void (*)(struct objc_super*, SEL, id))objc_msgSendSuper)(&sup, _cmd, viewControllers);
}

@end
