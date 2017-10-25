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
#import "NSView+SKPExtensions.h"

@implementation SKPInspector

- (instancetype)initWithRootView:(NSView *)rootView {
    if ( (self = [super init]) ) {
        _rootView = rootView;
    }
    return self;
}

- (NSStackView *)containerStack {
    NSView *container = [_rootView skp_subviewAtIndex:0];

    if ( ![container isKindOfClass:[NSStackView class]] ) {
        SKPLog("Inspector container type mistmatch. Expected NSStackView, found: %@", [container class]);
        return nil;
    }

    return (NSStackView *)container;
}

- (id<MSInspectorStackViewInterface>)contentStack {
    id inspectorScrollView = [self.containerStack skp_subviewAtIndexPath:SKP_INDEX_PATH(1, 0, 0, 0)];

    if ( ![inspectorScrollView isKindOfClass:[NSScrollView class]] ) {
        SKPLog("Failed to lookup inspector scroll view!");
        return nil;
    }

    id content = [(NSScrollView *)inspectorScrollView contentView].documentView;

    if ( ![content isKindOfClass:objc_getClass("MSInspectorStackView")] ) {
        SKPLog("Inspector content type mistmatch. Expected MSInspectorStackView, found: %@", [content class]);
        return nil;
    }

    if ( ![content isKindOfClass:[SKPInspectorStackView class]] ) {
        object_setClass(content, [SKPInspectorStackView class]);
    }

    return content;
}

@end
