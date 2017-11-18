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
        for ( id<SKPLayerObserver> observer in [self skp_layerObservers].allObjects ) {
            [observer object:obj didChangeProperty:prop inLayer:self];
        }
        ((void(*)(id, SEL, id, id))originalIMP)(self, callbackSEL, obj, prop);
    }));
}

- (void)skp_addLayerObserver:(id<SKPLayerObserver>)observer {
    [[self skp_layerObservers] addObject:observer];
}

- (void)skp_removeLayerObserver:(id<SKPLayerObserver>)observer {
    [[self skp_layerObservers] removeObject:observer];
}

- (NSHashTable *)skp_layerObservers {
    NSHashTable *observers = objc_getAssociatedObject(self, _cmd);
    if ( observers == nil ) {
        observers = [NSHashTable weakObjectsHashTable];
        objc_setAssociatedObject(self, _cmd, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observers;
}

@end
