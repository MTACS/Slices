//
//  SlicesViewHierarchy.m
//  Slices
//
//  Created by DF on 1/24/25.
//

#import "SlicesViewHierarchy.h"

@implementation SlicesViewHierarchy
+ (NSArray*)windowsElementTree:(NSDictionary*)properties skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots {
    
    NSMutableArray *tree = [NSMutableArray array];
    for (NSWindow *window in [NSApplication sharedApplication].windows) {
        if ([self mustReportTreeOfWindow:window properties:properties]) {
            NSDictionary * node = [self viewElementTree:(NSView *)window skipPrivateClasses:skipPrivate viewScreenshots:viewScreenshots];
            if (node) {
                [tree addObject:node];
            }
        }
    }
    return tree;
}
+ (NSArray *)mainWindowElementTree:(NSDictionary *)properties skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots {
    
    NSWindow *mainWindow = [self mainWindow:[NSApplication sharedApplication]];
    NSDictionary *node = [self viewElementTree:(NSView *)mainWindow skipPrivateClasses:skipPrivate viewScreenshots:viewScreenshots];
    return @[node];
}
+ (void)childNodes:(SlicesTreeNode *)node skipPrivateClasses:(BOOL)skipPrivate screenshots:(BOOL)takeScreenshots recursive:(BOOL)deep {
    NSView *startView;
    if ([node.view isKindOfClass:[NSWindow class]]) {
        NSWindow *window = (NSWindow *)node.view;
        startView = window.contentView;
    } else {
        startView = node.view;
    }
    
    for (NSView *subView in startView.subviews) {
        SlicesTreeNode *childNode = [[SlicesTreeNode alloc] initWithView:subView];
        [node.subviews addObject:childNode];
        if (deep) {
            [self childNodes:childNode skipPrivateClasses:skipPrivate screenshots:takeScreenshots recursive:deep];
        }
    }
}
+ (NSDictionary *)viewElementTree:(NSView *)view skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots {
    NSMutableDictionary *node = [NSMutableDictionary dictionary];

    if (!view) {
        return nil;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    for (NSView *subView in view.subviews) {
        NSDictionary *child = [self viewElementTree:subView skipPrivateClasses:skipPrivate viewScreenshots:viewScreenshots];
        if (child) {
            [children addObject:child];
        }
    }
    
    if (children.count) {
        node[@"subviews"] = children;
    }
    return node;
}
+ (NSDictionary *)elementInfoAtLocation:(CGPoint)location {
    NSDictionary *elementInfo;
    return elementInfo;
}
+ (BOOL)mustReportTreeOfWindow:(NSWindow*)window properties:(NSDictionary *)properties {
    BOOL result = true;
    return result;
}
+ (NSArray<NSWindow *>*)appWindows:(NSApplication *)app {
    NSMutableArray *windows = [NSMutableArray array];
    for (NSWindow *window in app.windows) {
        if (![window.identifier isEqualToString:@"com.mtac.slices"]) {
            [windows addObject:window];
        }
    }
    return windows;
}
+ (NSWindow *)keyWindow:(NSApplication *)app {
    return [app keyWindow];
}
+ (NSWindow *)mainWindow:(NSApplication *)app {
    return [app mainWindow];
}
@end
