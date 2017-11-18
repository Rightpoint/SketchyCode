//
//  NSArray+SKPExtensions.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SKPExtensions)

- (BOOL)skp_containsKindOfClass:(Class)cls;
- (BOOL)skp_containsMemberOfClass:(Class)cls;

- (BOOL)skp_areAllKindOfClass:(Class)cls;
- (BOOL)skp_areAllMembersOfClass:(Class)cls;

@end

@interface NSMutableArray (SKPExtensions)

- (void)skp_removeKindsOfClass:(Class)cls;
- (void)skp_removeMembersOfClass:(Class)cls;

@end
