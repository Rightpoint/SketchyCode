//
//  SKPCodeGenViewController.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SKPCodeGenViewController : NSViewController

/// This property is requires by children of MKInspectorStackView
@property (nonatomic, readonly) NSArray<NSView *>* views;

@end
