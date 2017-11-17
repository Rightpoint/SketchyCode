//
//  SKPStackOptionsViewController.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKPStackOptionsViewController : NSViewController

/// This property is requires by children of MKInspectorStackView
@property (nonatomic, readonly) NSArray<NSView *>* views;

@end
