//
//  NSView+SKPExtensions.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SKP_INDEX_PATH(idx...) ({ \
    const NSUInteger indexes[] = {idx}; \
    [NSIndexPath indexPathWithIndexes:indexes length:sizeof(indexes) / sizeof(NSUInteger)]; \
})

@interface NSView (SKPExtensions)

- (NSView *)skp_subviewAtIndex:(NSInteger)index;
- (NSView *)skp_subviewAtIndexPath:(NSIndexPath *)indexPath;

@end
