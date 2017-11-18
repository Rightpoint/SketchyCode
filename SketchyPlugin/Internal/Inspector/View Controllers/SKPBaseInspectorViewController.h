//
//  SKPBaseInspectorViewController.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/18/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKPBaseInspectorViewController : NSViewController

/// This property is required by children of MKInspectorStackView
@property (nonatomic, readonly) NSArray<NSView *>* views;

@end
