//
//  NSView+SKPExtensions.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "NSView+SKPExtensions.h"

@implementation NSView (SKPExtensions)

- (NSView *)skp_subviewAtIndex:(NSInteger)index {
    NSArray *subviews = [self subviews];
    return (index < subviews.count) ? subviews[index] : nil;
}

- (NSView *)skp_subviewAtIndexPath:(NSIndexPath *)indexPath {
    NSView *subview = self;

    for ( NSUInteger i = 0; i < indexPath.length && subview != nil; i++ ) {
        subview = [subview skp_subviewAtIndex:[indexPath indexAtPosition:i]];
    }

    return subview;
}

@end
