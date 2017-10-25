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
@protocol MSInspectorStackViewInterface;

@interface SketchInterface : NSObject

+ (id<MSDocumentInterface>)currentDocument;

+ (id<MSInspectorStackViewInterface>)inspectorStackView;

@end

@protocol MSDocumentInterface

@property (nonatomic, readonly) id<MSMainSplitViewControllerInterface> splitViewController;

@end

@protocol MSMainSplitViewControllerInterface

@property (nonatomic, readonly) NSView *inspectorView;

@end

@protocol MSInspectorStackViewInterface

@property (nonatomic, readonly) NSArray<NSViewController *> sectionViewControllers;

- (void)reloadWithViewControllers:(NSArray<NSViewController *>)viewControllers;

@end
