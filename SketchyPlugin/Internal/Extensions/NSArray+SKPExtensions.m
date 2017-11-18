//
//  NSArray+SKPExtensions.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "NSArray+SKPExtensions.h"

@implementation NSArray (SKPExtensions)

- (BOOL)skp_containsKindOfClass:(Class)cls {
    for ( id obj in self ) {
        if ( [obj isKindOfClass:cls] ) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)skp_containsMemberOfClass:(Class)cls {
    for ( id obj in self ) {
        if ( [obj isMemberOfClass:cls] ) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)skp_areAllKindOfClass:(Class)cls {
    for ( id obj in self ) {
        if ( ![obj isKindOfClass:cls] ) {
            return NO;
        }
    }
    return (self.count > 0);
}

- (BOOL)skp_areAllMembersOfClass:(Class)cls {
    for ( id obj in self ) {
        if ( ![obj isMemberOfClass:cls] ) {
            return NO;
        }
    }
    return (self.count > 0);
}

@end

@implementation NSMutableArray (SKPExtensions)

- (void)skp_removeKindsOfClass:(Class)cls {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isKindOfClass:cls];
    }];
    [self removeObjectsAtIndexes:indexes];
}

- (void)skp_removeMembersOfClass:(Class)cls {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isMemberOfClass:cls];
    }];
    [self removeObjectsAtIndexes:indexes];
}

@end
