//
//  SKPStackOptionsViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#import "SKPStackOptionsViewController.h"

@interface SKPStackOptionsViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;

@end

@implementation SKPStackOptionsViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([SKPStackOptionsViewController class]) bundle:[NSBundle bundleForClass:[SKPStackOptionsViewController class]]];
}

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    return @[self.headerView];
}

@end
