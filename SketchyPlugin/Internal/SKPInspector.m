//
//  SKPInspector.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPInspector.h"
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
    id inspectorScrollView = [_rootView skp_subviewAtIndexPath:SKP_INDEX_PATH(0, 1, 0, 0, 0)];

    if ( ![inspectorScrollView isKindOfClass:[NSScrollView class]] ) {
        SKPLog("Failed to lookup inspector scroll view!");
        return nil;
    }

    return [(NSScrollView *)inspectorScrollView contentView].documentView;
}

@end
