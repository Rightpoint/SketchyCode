//
//  SKPInspectorViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPInspectorViewController.h"

@interface SKPInspectorViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;

@end

@implementation SKPInspectorViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([SKPInspectorViewController class]) bundle:[NSBundle bundleForClass:[SKPInspectorViewController class]]];
}

- (NSArray<NSView *> *)views {
    // Ensure view is loaded
    __unused NSView *view = self.view;
    return @[self.headerView];
}

@end
