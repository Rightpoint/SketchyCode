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

+ (id<MSInspectorStackViewInterface>)inspectorStackView {
    NSView *inspectorContainer = [self currentDocument].splitViewController.inspectorView;
    id inspectorScrollView = [inspectorContainer skp_subviewAtIndexPath:SKP_INDEX_PATH(0, 1, 0, 0, 0)];

    if ( ![inspectorScrollView isKindOfClass:[NSScrollView class]] ) {
        SKPLog("Failed to lookup inspector scroll view!");
        return nil;
    }

    return [(NSScrollView *)inspectorScrollView contentView].documentView;

}

@end
