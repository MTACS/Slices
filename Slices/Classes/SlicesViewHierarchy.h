//
//  SlicesViewHierarchy.h
//  Slices
//
//  Created by DF on 1/24/25.
//

#import <Foundation/Foundation.h>
#import "SlicesTreeNode.h"

@interface SlicesViewHierarchy : NSObject
+ (void)childNodes:(SlicesTreeNode *)rootView skipPrivateClasses:(BOOL)skipPrivate screenshots:(BOOL)takeScreenshots recursive:(BOOL)deep;
+ (NSArray *)windowsElementTree:(NSDictionary *)properties skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots;
+ (NSArray*)mainWindowElementTree:(NSDictionary *)properties skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots;
+ (NSDictionary *)viewElementTree:(NSView*)rootView skipPrivateClasses:(BOOL)skipPrivate viewScreenshots:(BOOL)viewScreenshots;
+ (NSWindow *)keyWindow:(NSApplication*)app;
+ (NSWindow *)mainWindow:(NSApplication*)app;
+ (NSArray<NSWindow *>*)appWindows:(NSApplication *)app;
+ (NSDictionary *)elementInfoAtLocation:(CGPoint)location;
@end
