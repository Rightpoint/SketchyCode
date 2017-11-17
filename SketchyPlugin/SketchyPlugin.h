//
//  SketchyPlugin.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for SketchyPlugin.
FOUNDATION_EXPORT double SketchyPluginVersionNumber;

//! Project version string for SketchyPlugin.
FOUNDATION_EXPORT const unsigned char SketchyPluginVersionString[];

#import <SketchyPlugin/SketchInterface.h>

@interface SketchyPlugin : NSObject

+ (void)reloadInspector;

@end
