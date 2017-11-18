//
//  SketchInterface.h
//  SketchyPlugin
//
//  Created by Rob Visentin on 10/24/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

@import AppKit;

@protocol MSDocumentInterface;
@protocol MSMainSplitViewControllerInterface;
@protocol MSInspectorControllerInterface;
@protocol MSNormalInspectorInterface;
@protocol MSInspectorStackViewInterface;
@protocol MSLayerInterface;
@protocol MSLayerArrayInterface;
@protocol MSTextLabelForUpDownFieldInterface;
@protocol MSRectInterface;

@interface SketchInterface : NSObject

+ (id<MSDocumentInterface>)currentDocument;

+ (NSArray<id<MSLayerInterface>> *)selectedLayers;

@end

#pragma mark - MSDocument

@protocol MSDocumentInterface <NSObject>

@property (nonatomic, readonly) id<MSMainSplitViewControllerInterface> splitViewController;

@property (nonatomic, readonly) id<MSLayerArrayInterface> selectedLayers;

@end

#pragma mark - MSMainSplitViewController

@protocol MSMainSplitViewControllerInterface <NSObject>

@property (nonatomic, readonly) NSView *inspectorView;

@end

#pragma mark - MSInspectorControllerInterface

@protocol MSInspectorControllerInterface <NSObject>

@property (nonatomic, readonly) id<MSNormalInspectorInterface> normalInspector;

- (void)reload;

@end

#pragma mark - MSNormalInspectorInterface

@protocol MSNormalInspectorInterface <NSObject>

@property (nonatomic, readonly) id<MSInspectorStackViewInterface> stackView;

@end

#pragma mark - MSInspectorStackView

@protocol MSInspectorStackViewInterface <NSObject>

@property (nonatomic, readonly) NSArray<NSViewController *> *sectionViewControllers;

- (void)reloadWithViewControllers:(NSArray<NSViewController *> *)viewControllers;

@end

#pragma mark - MSLayer

@protocol MSLayerInterface <NSObject>

@property(nonatomic, readonly) NSString *objectID;

@property (nonatomic, readonly) id<MSRectInterface> frame;

@property (assign, nonatomic) CGRect rect;

@property (strong, nonatomic) NSDictionary *userInfo;

- (void)object:(id)object didChangeProperty:(NSString *)property;

@end

#pragma mark - MSLayerGroup

@protocol MSLayerGroupInterface<MSLayerInterface>

@property (nonatomic, readonly) NSArray<id<MSLayerInterface>> *layers;

- (void)disableAutomaticScalingInBlock:(void (^)(void))block;

@end

#pragma mark - MSLayerArray

@protocol MSLayerArrayInterface <NSObject>

@property (strong, nonatomic) NSArray<id<MSLayerInterface>> *layers;

@end

#pragma mark - MSTextLabelForUpDownField

@protocol MSTextLabelForUpDownFieldInterface <NSObject>

- (void)setTextFields:(NSArray *)textFields;

@end

#pragma mark - MSRectInterface

@protocol MSRectInterface <NSObject>

@property (assign, nonatomic) CGRect rect;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;

@end
