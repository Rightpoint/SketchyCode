//
//  SketchInterface.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.message;

#import "SketchyPlugin.h"

@implementation SketchInterface

+ (id<MSDocumentInterface>)currentDocument {
    return ((id<MSDocumentInterface>(*)(id, SEL))objc_msgSend)(objc_getClass("MSDocument"), sel_getUid("currentDocument"));
}

@end
