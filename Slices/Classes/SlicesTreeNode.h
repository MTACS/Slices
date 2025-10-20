//
//  SlicesTreeNode.h
//  Slices
//
//  Created by DF on 1/24/25.
//

#import <Foundation/Foundation.h>
#import "NSObject+Slices.h"

NS_ASSUME_NONNULL_BEGIN

struct OpaqueNodeRef;

struct TFENode {
    struct OpaqueNodeRef *x0;
};

@interface FINode : NSObject
@property (readonly, copy, nonatomic) NSURL *fileURL;
@property (readonly, nonatomic) NSArray *itemDecorations;
+ (id)_allRootInstances;
+ (id)nodeFromNodeRef:(struct OpaqueNodeRef *)ref;
- (id)debugDescription;
- (id)longDescription;
- (id)previewItemURL;
- (id)launchURL;
@end

@interface NSView (Slices)
- (NSViewController *)parentViewController;
@end

@interface SlicesTreeNode : NSObject
@property (nonatomic, weak) NSView *view;
@property (nonatomic) NSMutableArray<SlicesTreeNode *> *subviews;
- (instancetype)initWithView:(nonnull NSView *)view;
- (NSArray *)ivars;
- (NSArray *)properties;
- (NSString *)title;
- (NSString *)description;
- (NSImage *)image;
- (void)copyClassName;
@end

NS_ASSUME_NONNULL_END
