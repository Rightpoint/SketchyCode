//
//  SKPStackOptionsViewController.m
//  SketchyPlugin
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import ObjectiveC.message;

#import "SKPStackOptionsViewController.h"
#import "SketchyPlugin.h"
#import "SKPStackGroupProxy.h"
#import "NSArray+SKPExtensions.h"
#import "SKPMacros.h"

@interface SKPStackOptionsViewController ()

@property (strong, nonatomic) IBOutlet NSView *headerView;
@property (strong, nonatomic) IBOutlet NSView *convertView;
@property (strong, nonatomic) IBOutlet NSView *multipleView;
@property (strong, nonatomic) IBOutlet NSView *optionsView;

@property (weak, nonatomic) IBOutlet NSButton *convertButton;

@property (weak, nonatomic) IBOutlet NSTextField *spacingLabel;
@property (weak, nonatomic) IBOutlet NSTextField *spacingField;

@property (nonatomic, readonly) NSMutableArray *stackProxies;

@end

@implementation SKPStackOptionsViewController

@synthesize stackProxies = _stackProxies;

- (void)awakeFromNib {
    [super awakeFromNib];
    [(id<MSTextLabelForUpDownFieldInterface>)self.spacingLabel setTextFields:@[self.spacingField]];
}

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.headerView];

    NSArray *selectedLayers = SketchInterface.selectedLayers;

    if ( selectedLayers.count > 1 ) {
        [views addObject:self.multipleView];
    }
    else {
        [views addObject:self.convertView];

        if ( [SKPStackGroupProxy layerHasBeenProxied:(id<MSLayerGroupInterface>)[selectedLayers firstObject]] ) {
            [views addObject:self.optionsView];
        }
    }

    return views;
}

- (void)viewWillAppear {
    [super viewWillAppear];

    [self initializeProxies];

    NSUInteger selectedCount = SketchInterface.selectedLayers.count;
    NSUInteger proxyCount = self.stackProxies.count;

    if ( proxyCount == 0 ) {
        self.convertButton.state = NSControlStateValueOff;
    }
    else if ( proxyCount < selectedCount ) {
        self.convertButton.state = NSControlStateValueMixed;
    }
    else {
        self.convertButton.state = NSControlStateValueOn;
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    if ( [key hasPrefix:@"stack"] ) {
        key = [[key stringByReplacingOccurrencesOfString:@"stack" withString:@""] lowercaseString];
        NSArray *values = [self.stackProxies valueForKey:key];

        if ( [[values firstObject] isEqual:[NSNull null]] ) {
            return nil;
        }
        else {
            return [values firstObject];
        }
    }
    else {
        return [super valueForKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ( [key hasPrefix:@"stack"] ) {
        key = [[key stringByReplacingOccurrencesOfString:@"stack" withString:@""] lowercaseString];

        for ( SKPStackGroupProxy *proxy in self.stackProxies ) {
            [proxy setValue:value forKey:key];
        }
    }
    else {
        [super setValue:value forUndefinedKey:key];
    }
}

#pragma mark - private

- (NSMutableArray *)stackProxies {
    if ( _stackProxies == nil ) {
        _stackProxies = [NSMutableArray array];
    }
    return _stackProxies;
}

- (void)initializeProxies {
    [self.stackProxies removeAllObjects];

    // These keys are bound to the various UI elements of optionsView
    NSArray *changeKeys = @[@"stackAxis", @"stackAlignment", @"stackDistribution", @"stackSpacing"];

    for ( NSString *key in changeKeys ) {
        [self willChangeValueForKey:key];
    }

    for ( id<MSLayerGroupInterface> layer in SketchInterface.selectedLayers ) {
        if ( [SKPStackGroupProxy layerHasBeenProxied:layer] ) {
            [self.stackProxies addObject:[SKPStackGroupProxy proxyForLayer:layer]];
        }
    }

    for ( NSString *key in changeKeys ) {
        [self didChangeValueForKey:key];
    }
}

- (IBAction)convertButtonPressed:(NSButton *)sender {
    [self.stackProxies removeAllObjects];

    for ( id<MSLayerGroupInterface> layer in SketchInterface.selectedLayers ) {
        SKPStackGroupProxy *proxy = [SKPStackGroupProxy proxyForLayer:layer];

        if ( sender.state == NSControlStateValueOn ) {
            [self.stackProxies addObject:proxy];
        }
        else if ( sender.state == NSControlStateValueOff ) {
            [proxy stopProxying];
        }
    }

    [SketchyPlugin reloadInspector];
}

@end
