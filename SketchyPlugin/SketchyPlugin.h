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

#define SKPLog(fmt, ...) NSLog((@"(Sketchy Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import <SketchyPlugin/SketchInterface.h>

@interface SketchyPlugin : NSObject

+ (void)reloadInspector;

@end
