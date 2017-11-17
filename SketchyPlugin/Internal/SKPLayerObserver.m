//
//  SKPRectObserver.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.runtime;

#import "SKPLayerObserver.h"

@implementation NSObject (SKPLayerObserver)

+ (void)load {
    Class layerClass = objc_getClass("MSLayer");

    if ( layerClass == nil ) {
        return;
    }

    SEL callbackSEL = @selector(object:didChangeProperty:);
    Method callback = class_getInstanceMethod(layerClass, callbackSEL);

    if ( callback == nil ) {
        return;
    }

    __block IMP originalIMP = method_setImplementation(callback, imp_implementationWithBlock(^(id self, id obj, id prop) {
        ((void(*)(id, SEL, id, id))originalIMP)(self, callbackSEL, obj, prop);
        [[self skp_layerObserver] object:obj didChangeProperty:prop];
    }));
}

- (id<SKPLayerObserver>)skp_layerObserver {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSkp_layerObserver:(id<SKPLayerObserver>)observer {
    objc_setAssociatedObject(self, @selector(skp_layerObserver), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
