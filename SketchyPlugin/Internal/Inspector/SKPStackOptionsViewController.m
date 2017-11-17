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
#import "SKPStackViewProxy.h"
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

@property (strong, nonatomic, readonly) NSMapTable *layerProxies;

@end

@implementation SKPStackOptionsViewController

@synthesize layerProxies = _layerProxies;

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass([SKPStackOptionsViewController class]) bundle:[NSBundle bundleForClass:[SKPStackOptionsViewController class]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [(id<MSTextLabelForUpDownFieldInterface>)self.spacingLabel setTextFields:@[self.spacingField]];
}

- (NSArray<NSView *> *)views {
    __unused NSView *view = self.view;
    NSMutableArray *views = [NSMutableArray arrayWithObjects:self.headerView, self.convertView, nil];

    if ( SketchInterface.selectedLayers.count == 1 ) {
        [views addObject:self.optionsView];
    }
    else {
        [views addObject:self.multipleView];
    }

    return views;
}

- (void)viewWillAppear {
    [super viewWillAppear];

    [self initializeProxies];

    NSUInteger proxyCount = self.layerProxies.count;
    NSUInteger selectedCount = SketchInterface.selectedLayers.count;

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

#pragma mark - private

- (NSMapTable *)layerProxies {
    if ( _layerProxies == nil ) {
        _layerProxies = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _layerProxies;
}

- (void)initializeProxies {
    [self.layerProxies removeAllObjects];

    for ( id<MSLayerGroupInterface> layer in SketchInterface.selectedLayers ) {
        if ( [SKPStackViewProxy layerContainsStackConfiguration:layer] ) {
            SKPStackViewProxy *proxy = [[SKPStackViewProxy alloc] initProxying:layer];
            [self.layerProxies setObject:proxy forKey:layer];
        }
    }
}

- (IBAction)convertButtonPressed:(NSButton *)sender {
    for ( id<MSLayerGroupInterface> layer in SketchInterface.selectedLayers ) {
        if ( sender.state == NSControlStateValueOn ) {
            SKPStackViewProxy *proxy = [[SKPStackViewProxy alloc] initProxying:layer];
            [self.layerProxies setObject:proxy forKey:layer];
        }
        else if ( sender.state == NSControlStateValueOff ) {
            SKPStackViewProxy *proxy = [self.layerProxies objectForKey:layer];
            [proxy stopProxying];
            [self.layerProxies removeObjectForKey:layer];
        }
    }
}

@end
